class Destination < ActiveRecord::Base
    has_many :jots
    has_many :users, through: :jots
end