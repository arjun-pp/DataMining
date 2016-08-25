class AddNeighbourhoods < ActiveRecord::Migration
  	def change
  		create_table :neighbourhoods do |t|
  			t.text :name, null: false, unique: true
  			t.text :polygon
  			t.decimal :lat
  			t.decimal :long
  			t.timestamps 
	        add_index :neighbourhoods, [:name, :area_id], unique: true

  	end
end
