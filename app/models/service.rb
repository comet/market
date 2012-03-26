class Service < ActiveRecord::Base

  has_many :ratings
  has_many :raters, :through => :ratings, :source => :people
  #has_one :service_file,:dependent => destroy
  scope :performed, where(:status => 'done')
  scope :pending, where(:status => 'pending')
  scope :cancelled, where(:status => 'cancelled')
  belongs_to :listings, :class_name => "Listing", :foreign_key => "author_id"
end
