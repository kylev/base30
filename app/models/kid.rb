class Kid < ActiveRecord::Base
  belongs_to :parent, :counter_cache => true
end
