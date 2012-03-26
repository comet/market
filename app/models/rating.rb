class Rating < ActiveRecord::Base
  attr_accessible :value

    belongs_to :service
    belongs_to :person
end
