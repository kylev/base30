require 'redis_counter_cache'
ActiveRecord::Base.send(:include, RedisCounterCache)
