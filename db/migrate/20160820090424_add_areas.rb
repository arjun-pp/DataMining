class AddAreas < ActiveRecord::Migration
  	def change
		create_table :areas do |t|
  			t.text :name, null: false, unique: true
  			t.text :polygon
  			t.decimal :lat
  			t.decimal :long
  			t.timestamps 
        add_index :areas, [:name, :sector_id], unique: true
  		end
  	end
end
