class AddSectors < ActiveRecord::Migration
	def change
		create_table :sectors do |t|
  			t.text :name, null: false
  			t.text :polygon
  			t.decimal :lat
  			t.decimal :long
  			t.timestamps 
        t.real_estate_cost :int
        add_index :sectors, [:name, :city_id], unique: true
  		end
	end
end