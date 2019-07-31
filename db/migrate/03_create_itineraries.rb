class CreateItineraries < ActiveRecord::Migration[4.2]
    def change
        create_table :itinerary_lists do |t|
            t.text :itinerary
            t.integer :user_id
            t.integer :destination_id
        end 
    end
end