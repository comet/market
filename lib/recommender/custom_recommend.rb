class CustomRecommend
  attr_accessor :diffs, :freqs ,:weights ,:weighted_array

  def initialize
    self.diffs = {}
    self.freqs = {}
    self.weights= {
        :category=>0.25,
        :times_viewed=>0.25,
        :price=>0.025,
        :time_frame=>0.025,
        :tags=>0.5,
        :rankings=>0.75
    }
    self.weighted_array=[]

  end

  def insert_static(user_data)
    user_data.each do |name, ratings|
      ratings.each do |item1, rating1|
        self.freqs[item1] ||= {}
        self.diffs[item1] ||= {}
        ratings.each do |item2, rating2|
          self.freqs[item1][item2] ||= 0
          self.diffs[item1][item2] ||= 0.0
          self.freqs[item1][item2] += 1
          self.diffs[item1][item2] += (rating1 - rating2)
        end
      end
    end

    self.diffs.each do |item1, ratings|
      ratings.each do |item2, rating2|
        ratings[item2] = ratings[item2] / self.freqs[item1][item2]
      end
    end
  end
  def insert(listings_array, listing)
    listings_array.each do |list_item|
    end
  end
  def load_weights(listings_array,listing)

       listings_array.each do|listing_item|
         hash={}
         if listing_item.category.eql?(listing.category)
           #assign weights to each item of the same category
           hash = {:id=>listing_item.id,
           :value=>1*self.weights[:category]
           }
           if listing_item.times_viewed > 0
             hash[:value]+=listing_item.times_viewed*self.weights[:times_viewed]
           end
           if listing_item.price.eql?(listing.price)
             hash[:value]+=listing_item.price*self.weights[:price]
           end
           if listing_item.time_frame.eql?(listing.time_frame)
             hash[:value]+=listing_item.time_frame*self.weights[:time_frame]
           end
           #get all tags for that listing
           tags= listing.tags
           listing_item_tags=listing_item.tags

           if tags && listing_item_tags
             #compare tags
            tags.each do |tag|
               if listing_item_tags.include? (tag)
                 hash[:value]+=1*self.weights[:tags]
               end
            end
           end
           #get listing_ranking
           services = listing_item.services
           size=0
           services.each do |service|service.rating

           if service.rating
             size+=1
           end
            rankings +=service.rating.value if service.rating.value
           end
           average_ranking= (rankings/size)
           if average_ranking
             hash[:value]+=average_ranking*self.weights[:rankings]
           end
         end
         #add the hash to the array
       self.weighted_array<<hash
       end
       Rails.logger.debug{self.weighted_array.inspect}
    return self.weighted_array
  end

  def predict(listings_array, listing)
    weight = load_weights(listings_array,listing)
     Rails.logger.debug{weight.inspect}
    #return listings_array

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
   closer_listings
    return predict(@related_categories,listing)
  end
end