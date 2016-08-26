class AddSectors < ActiveRecord::Migration
	def change
		create_table :sectors do |t|
        t.belongs_to :cities, index: true
        t.text :name, null: false
        t.text :polygon
        t.decimal :lat
        t.decimal :long
        t.timestamps
        t.integer :real_estate_cost
  		end
	end
end