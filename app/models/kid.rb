class Kid < ActiveRecord::Base
  belongs_to :parent, :redis_counter_cache => true
end
