class Rating < ActiveRecord::Base
  attr_accessible :value,:text
    validates_presence_of :value
    belongs_to :service
    belongs_to :person

end
