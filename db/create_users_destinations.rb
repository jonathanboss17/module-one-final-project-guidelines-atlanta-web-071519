class CreateUsersDestinations < ActiveRecord::Migration[4.2]
    def change
        create_table :users_destinations do |t|
            t.integer :user_id
            t.integer :destination_id
        end 
    end
end