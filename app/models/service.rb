class Service < ActiveRecord::Base

  has_one :rating
  has_many :raters, :through => :ratings, :source => :people
  #has_one :service_file,:dependent => destroy
  scope :performed, where(:status => 'done')
  scope :pending, where(:status => 'pending')
  scope :cancelled, where(:status => 'cancelled')
  belongs_to :listings, :class_name => "Listing", :foreign_key => "author_id"
  VALID_NOTIFICATION_TIMES=[0,1,3,6,12,24,36,48,72]
  def average_rating
    @value = 0
    #self.rating.each do |rating|
    unless self.rating.nil?
      @value=self.rating.value.to_s
    end
    @value
    #end
    #@total = self.ratings.size
    #@value.to_f / @total.to_f
  end
  def update_payment_attributes(args=nil)
    price=Listing.find(listing_id).price
    unless price.nil?
      @cash_change = Cashflow.new
      @cash_change.amount=price
      @cash_change.user_id=receiver_id.to_s
      @cash_change.sender_user_id=author_id.to_s
      @cash_change.listing_id=listing_id
      @cash_change.approved=0
      if @cash_change.save
      #payment done
        return true
      else
        Rails.logger.error{"Failed saving the damn cash transfer"}
        return false
      end
    end
  end
  def self.check_overdue_tasks
    pending_services=Service.find_by_sql("SELECT * FROM services INNER JOIN listings ON services.listing_id=listings.id WHERE services.status=#{"pending"}")
    if  pending_services&&pending_services.size >0
        pending_services.each do |service|
          time=Time.now-service.created_at
          Rails.logger.debug{time.to_s}
          if time.hours<72
            Rails.logger.debug{time.to_s+"Less than 72 hours"}
          elsif time.hours<48
            Rails.logger.debug{time.to_s+"Less than 48 hours"}
          elsif time.hours<36
            Rails.logger.debug{time.to_s+"Less than 36 hours"}
          elsif time.hours<24
            Rails.logger.debug{time.to_s+"Less than 24 hours"}
          elsif time.hours<12
            Rails.logger.debug{time.to_s+"Less than 12 hours"}
          elsif time.hours<6
            Rails.logger.debug{time.to_s+"Less than 6 hours"}
          elsif time.hours<3
            Rails.logger.debug{time.to_s+"Less than 3 hours"}
          elsif time.hours<1
            Rails.logger.debug{time.to_s+"Less than 1 hour"}
          else
            if time.minutes<0

            end

          end
        end
    end
  end
end
