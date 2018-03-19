# frozen_string_literal: true

module Sidekiq
  module SkipRetry
    # Middleware to support skip retry: catches excpetion and sets
    # skiping if worker marked itself as skipped
    class Middleware
      def call(worker, job, _queue)
        yield
      rescue StandardError => e
        skip_default_retry(job) if worker.retry_skipped?
        raise e
      end

      private

      def skip_default_retry(job)
        job['retry'] = false
      end
    end
  end
end

# Plugin middleware to sidekiq automatically
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::SkipRetry::Middleware
  end
end
