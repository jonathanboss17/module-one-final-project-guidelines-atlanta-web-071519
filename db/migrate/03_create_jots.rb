class CreateJots < ActiveRecord::Migration[4.2]
    def change
        create_table :jots do |t|
            t.text :jot
            t.integer :user_id
            t.integer :destination_id
        end 
    end
end