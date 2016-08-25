require 'housing'
namespace :scrape do
	desc 'Scrape housing API , process the results and insert into db'
	task housing_api: :environment do
		Housing.new().process_polygon_api()
	end
end