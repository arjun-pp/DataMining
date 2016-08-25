class AddCities < ActiveRecord::Migration
	def change
    	create_table :cities do |t|
      		t.text :name, null: false, unique: true
      		t.text :polygon
      		t.decimal :lat
      		t.decimal :long
      		t.timestamps 
    	end
  	end
end
