class CreateDestinations < ActiveRecord::Migration[4.2]
    def change
        create_table :destinations do |t|
            t.string :city
            t.string :state_or_country  
        end 
    end
end