require 'spec_helper'

describe RateLimiter::TimedLimiter do
  subject { RateLimiter::TimedLimiter }

  before(:each) do
    Redis.new.flushdb
  end

  it 'should be able to rate limit' do
    counter = 0

    current_time = 10
    limiter = subject.new('foobar', interval: 10, rate: 2, clock: -> { current_time })

    expect(limiter.limit { counter += 1 }).to eq true
    expect(limiter.limit { counter += 1 }).to eq true
    expect(limiter.limit { counter += 1 }).to eq false
    expect(counter).to eq 2
  end

  it 'should be able to reset after a time interval' do
    counter = 0

    current_time = 10
    limiter = subject.new('foobar', interval: 10, rate: 2, clock: -> { current_time })

    expect(limiter.limit { counter += 1 }).to eq true
    expect(limiter.limit { counter += 1 }).to eq true
    expect(counter).to eq 2

    current_time = 20
    expect(limiter.limit { counter += 1 }).to eq true
    expect(limiter.limit { counter += 1 }).to eq true
    expect(counter).to eq 4
  end

  it 'should know when limit is exceeded' do
    counter = 0

    current_time = 10
    limiter = subject.new('foobar', interval: 10, rate: 2, clock: -> { current_time })

    expect(limiter.limit { counter += 1 }).to eq true
    expect(limiter.limit { counter += 1 }).to eq true
    expect(counter).to eq 2

    expect(limiter.exceeded?).to eq true
  end

  it 'should be able to increment on its own' do
    current_time = 10
    limiter = subject.new('foobar', interval: 10, rate: 2, clock: -> { current_time })

    expect(limiter.increment!).to eq true
    expect(limiter.increment!).to eq true
    expect(limiter.exceeded?).to eq true

    expect(limiter.increment!).to eq false
  end
end
