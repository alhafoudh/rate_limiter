module RateLimiter
  class TimedLimiter
    attr_reader :resource_name
    attr_reader :interval
    attr_reader :rate
    attr_reader :redis
    attr_reader :clock

    def initialize(resource_name, interval:, rate:, redis: Redis.new, clock: -> { Time.now })
      @resource_name = resource_name
      @interval      = interval
      @rate          = rate
      @redis         = redis
      @clock         = clock
    end


    def key_name
      "%s::%s:%d" % [self.class.to_s, resource_name, period]
    end

    def current_value
      redis.get(key_name).to_i
    end

    def timestamp
      clock.call
    end

    def period
      (timestamp.to_f / interval.to_f).floor
    end

    def limit(&block)
      executed = unless exceeded?
        block.call
        true
      else
        false
      end

      increment!
      executed
    end

    def increment!
      unless exceeded?
        redis.multi do
          redis.incr(key_name)
          redis.expire(key_name, interval)
        end
        true
      else
        false
      end
    end

    def exceeded?
      current_value >= rate
    end
  end
end
