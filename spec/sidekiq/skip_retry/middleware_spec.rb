# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sidekiq::SkipRetry::Middleware do
  let(:worker_class) do
    Class.new do
      include ::Sidekiq::Worker

      def perform
        skip_retry
        raise StandardError, 'Testing error'
      end
    end
  end
  let(:worker) { worker_class.new }

  it 'reraise original exeption and sets job config retry flag to false' do
    job = { 'args' => [] }
    expect { subject.call(worker, job, :queue) { worker.perform } }.to(
      raise_error do |error|
        expect(error).to be_a(StandardError)
        expect(job['retry']).to eq false
      end
    )
  end
end
