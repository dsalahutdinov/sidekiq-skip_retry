# frozen_string_literal: true

module Sidekiq
  module SkipRetry
    # Extension module for Sidekiq::Worker to mark worker for skipping retry
    module Worker
      def skip_retry
        @retry_skipped = true
      end

      def retry_skipped?
        @retry_skipped
      end
    end
  end
end

# Applies extention to any sidekiq worker
Sidekiq::Worker.include(Sidekiq::SkipRetry::Worker)
