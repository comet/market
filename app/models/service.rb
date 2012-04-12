class Service < ActiveRecord::Base

  has_one :rating
  has_many :raters, :through => :ratings, :source => :people
  #has_one :service_file,:dependent => destroy
  scope :performed, where(:status => 'done')
  scope :pending, where(:status => 'pending')
  scope :cancelled, where(:status => 'cancelled')
  belongs_to :listings, :class_name => "Listing", :foreign_key => "author_id"
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
end
