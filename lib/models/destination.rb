class Destination < ActiveRecord::Base
    has_many :itinerary_lists 
    has_many :users, through: :itinerary_lists
end 