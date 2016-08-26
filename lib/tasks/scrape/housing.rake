#Tasks to get residential data

require 'housing'
require 'scraper'
namespace :scrape do
	desc 'Scrape housing API , process the results and insert into db'
	task :housing_api => :environment do
		Housing.new.process_polygon_api
  end

  desc 'Scrape website , process the results and insert into db'
  task :website, [ :url, :css_class] => :environment do |t, args|
    Scraper.new(args.url, args.css_class).scrape_for_infinite_scroll
  end
  #TODO: change to single scraper and detect pagination
  desc 'Scrape website with pagination , process the results and insert into db'
  task :website_pagination, [ :url, :css_class, :pagination_css, :selected_page_css] => :environment do |t, args|
    Scraper.new(args.url, args.css_class, args.pagination_css, args.selected_page_css).scrape_for_pagination
  end
end