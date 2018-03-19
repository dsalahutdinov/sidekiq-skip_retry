# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sidekiq::SkipRetry do
  it 'has a version number' do
    expect(Sidekiq::SkipRetry::VERSION).not_to be nil
  end
end
