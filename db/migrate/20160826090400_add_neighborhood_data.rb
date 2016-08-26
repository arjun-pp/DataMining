class AddNeighborhoodData < ActiveRecord::Migration
  def change
    create_table :neighbourhood_data do |t|
      t.text :name
      t.text :source_url
      t.text :html_data
      t.text :data_css
    end
  end
end
