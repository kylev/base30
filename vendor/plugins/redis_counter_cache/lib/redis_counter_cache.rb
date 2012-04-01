module RedisCounterCache
  extend ActiveSupport::Concern

  module ClassMethods
    def reset_redis_counters(id, *counters)
      object = find(id)
      counters.each do |association|
        has_many_association = reflect_on_association(association.to_sym)

        expected_name = if has_many_association.options[:as]
          has_many_association.options[:as].to_s.classify
        else
          self.name
        end

        child_class  = has_many_association.klass
        belongs_to   = child_class.reflect_on_all_associations(:belongs_to)
        reflection   = belongs_to.find { |e| e.class_name == expected_name }
        counter_name = reflection.counter_cache_column

        redis_counter_conn.incrby "#{name}:#{id}:#{counter_name}", object.send(association).count
      end
      return true
    end

    def update_redis_counters(id, counters)
      # TODO Pipelined
      updates = counters.map do |counter_name, value|
        redis_counter_conn.incrby "#{name}:#{id}:#{counter_name}", value
      end
    end

    def increment_redis_counter(counter_name, id)
      update_redis_counters(id, counter_name => 1)
    end

    def decrement_redis_counter(counter_name, id)
      update_redis_counters(id, counter_name => -1)
    end

  end

  module InstanceMethods
  end
end

class ActiveRecord::Base
  include RedisCounterCache
end
