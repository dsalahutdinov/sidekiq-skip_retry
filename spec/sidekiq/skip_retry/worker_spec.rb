# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sidekiq::SkipRetry::Worker do
  let(:worker) { worker_class.new }
  let(:worker_class) do
    Class.new do
      include ::Sidekiq::Worker
    end
  end

  it 'saves skip flag when skip_retry is called' do
    expect { worker.skip_retry }.to change { worker.retry_skipped? }.to(true)
  end
end
