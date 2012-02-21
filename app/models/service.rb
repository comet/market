class Service < ActiveRecord::Base

  #has_one :service_file,:dependent => destroy
  scope :performed, where(:status => 'done')
  scope :pending, where(:status => 'pending')
  belongs_to :listings, :class_name => "Listing", :foreign_key => "author_id"
end