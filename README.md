# rate_limiter

This library allows you to rate-limit resource access.

## Installation

Add this line to your application's Gemfile:

    gem 'rate_limiter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rate_limiter

## Usage

```ruby
require 'rate_limiter'

include RateLimiter
limiter = TimedLimiter.new('my_resource', period: 10, rate: 20) # limit resource to 20 requests over 10 seconds

executed = limiter.limit do
  # request some resource
end

if executed
  # block was executed
else
  # block was not executed due to rate limiting
end

limiter.exceeded?

limiter.increment!

```

## Contributing

1. Fork it ( https://github.com/alhafoudh/rate_limiter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
