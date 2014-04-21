require 'spec_helper'

describe RateLimiter do
  it 'should have a version number' do
    expect(RateLimiter::VERSION).not_to be_nil
  end
end
