class CreateItineraries < ActiveRecord::Migration[4.2]
    def change
        create_table :itinerary_lists do |t|
            t.index :user_id
            t.index :destination_id
            t.text :itinerary 
        end 
    end
end