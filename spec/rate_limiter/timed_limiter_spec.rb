require 'spec_helper'

describe RateLimiter::TimedLimiter do
  subject { RateLimiter::TimedLimiter }

  before(:each) do
    Redis.new.flushdb
  end

  it 'should be able to rate limit' do
    limiter = subject.new('foobar', period: 10, rate: 5)
    counter = 0

    current_time = 10
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq false
    expect(counter).to eq 5
  end

  it 'should be able to reset after a time period' do
    limiter = subject.new('foobar', period: 10, rate: 5)
    counter = 0

    current_time = 10
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(counter).to eq 5

    current_time = 20
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(limiter.limit(current_time) { counter += 1 }).to eq true
    expect(counter).to eq 10
  end
end
