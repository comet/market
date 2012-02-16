class Service < ActiveRecord::Base

  #has_one :service_file,:dependent => destroy
  scope :performed, where(:status => 'done')
  scope :pending, where(:status => 'pending')
end
