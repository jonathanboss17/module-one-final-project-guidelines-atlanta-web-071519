class CreateDestinations < ActiveRecord::Migration[4.2]
    def change
        create_table :destinations do |t|
            t.string :city
            t.string :state_or_country
            t.text :what_to_do  
        end 
    end
end