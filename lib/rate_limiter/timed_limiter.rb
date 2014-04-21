module RateLimiter
  class TimedLimiter
    attr_reader :resource_name
    attr_reader :period
    attr_reader :rate
    attr_reader :redis

    def initialize(resource_name, period:, rate:, redis_options: {})
      @resource_name = resource_name
      @period        = period
      @rate          = rate
      @redis         = Redis.new(redis_options)
    end

    def limit(time = Time.now)
      timestamp = (time.to_f / period.to_f).floor
      keyname = "%s::%s:%d" % [self.class.to_s, resource_name, timestamp]
      current = redis.get(keyname).to_i

      executed = if current < rate
        yield
        true
      else
        false
      end

      redis.multi do
        redis.incr(keyname)
        redis.expire(keyname, period)
      end

      executed
    end
  end
end
