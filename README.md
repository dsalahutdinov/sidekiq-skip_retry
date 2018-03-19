# Sidekiq::Skip::Retry

Gem `sidekiq-skip_retry` allows you to set up skipping default retry depending of error you have in your worker.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-skip-retry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-skip-retry

## Usage

For expample, we have sidekiq worker to fetch some data from Twitter via API:
```ruby
class TweetsFetcher
  include ::Sidekiq::Worker

  # you want to use automatic sidekiq retry in case of network errors
  sidekiq_options queue: :twitter,
                  retry: 3
  def perform
    client = Twitter::REST::Client.new(config)
    client.search('Leonhard Euler').each |tweet|
      # do something with data
    end
  end
end
```
In case of having network error - this worker will fail and will be rescheduled to retry in some time. This is great, but how to deal with case it is fails with [rate limit error](https://github.com/sferik/twitter/blob/aa909b3b7733ca619d80f1c8cba961033d1fc7e6/examples/RateLimiting.md#rate-limits) and you want to reschedule it for the time when request's limit constraint will be removed?


This gem will help you to make this, keeping things simple and holding logic in the same worker class:
```ruby
class TweetsFetcher
  include ::Sidekiw::Worker

  sidekiq_options retry: 3

  def perform
    # working with Twitter API logic, which may fail with Twitter::Error::TooManyRequests

    rescue Twitter::Error::TooManyRequests => e
      skip_retry
      retry_in(e.rate_limit)
      raise e
    rescue Twitter::Error::Unauthorized => e
      # if for any reason you do not want to retry the same request
      skip_retry
      notify(e)
      raise e
    end

    private

    def retry_in(retry_time)
      logger.info("Reschedule fetch twitter data at #{retry_time} beause of rate limit error")
      FetchTwitter.perform_at(retry_time)
    end

    def notify(e)
      # send email message or anything else
    end
```

Works with help of sidekiq middleware intercepting the error and changing the retry option of job, [as described here](https://github.com/mperham/sidekiq/issues/2072#issuecomment-247588145).

The same way you can rescue many errors and define do you need to skip the error in that case, or not.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sidekiq-skip-retry.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
