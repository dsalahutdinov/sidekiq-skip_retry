# frozen_string_literal: true

require 'sidekiq/skip_retry/version'
require 'sidekiq'
require 'sidekiq/skip_retry/middleware'
require 'sidekiq/skip_retry/worker'
require 'sidekiq/skip_retry/rspec' if defined?(RSpec)

module Sidekiq
  # Skip default sidekiq retry logic module
  module SkipRetry
  end
end
