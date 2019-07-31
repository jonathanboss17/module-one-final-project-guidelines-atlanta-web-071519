class User < ActiveRecord::Base 
    has_many :itinerary_lists
    has_many :destinations, through: :itinerary_lists
end