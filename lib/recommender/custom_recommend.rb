class CustomRecommend
  attr_accessor :diffs, :freqs

  def initialize
    self.diffs = {}
    self.freqs = {}
  end

  def insert(listings_array, listing)
    listings_array.each do |list_item|

    end
  end

  def predict(listings_array, listing)

  end

  def predict_basic(listing, threshold)
    accepted_closer_listings=[]
    closer_listings = []
    ratings[0, 0.25, 0.5, 0.75, 1]
    category=listing.category
    tags=listing.tags
    ratings={}
    #compare all the listings to the ratings
    if category
      @related_categories = Listing.find_by_sql("Select * from listings where category='#{category}'  LEFT JOIN ratings on listings.author_id=ratings.user_id")
    end
    if @related_categories.size >0
      #sift the array based on tags and rankings
      ratings.each do |rating|
        #empty this array on every request
        accepted_closer_listings=closer_listings
        closer_listings=[]
        @related_categories.each do |related_listing|
          #make sure that the service is rated above fair
          if related_listing.value && related_listing.value > rating
            closer_listings<<related_listing.id
          end
        end
        if closer_listings.size<threshold
          closer_listings=accepted_closer_listings
          break;
        end
      end
    end
    Rails.logger.debug { "Using this set of predicted set" }
    Rails.logger.debug { closer_listings.inspect }
    return closer_listings
  end
end