class JobPayment < ActiveRecord::Base
  validates_presence_of :user_id,:listing_id,:payment_id
end
