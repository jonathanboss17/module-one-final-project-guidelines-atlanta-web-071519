class User < ActiveRecord::Base 
    has_many :jots
    has_many :destinations, through: :jots
end