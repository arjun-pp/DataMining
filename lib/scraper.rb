class Scraper
	def initialize url, css_class
		@url = url
		@css_class= css_class
		@driver = Selenium::WebDriver.for :firefox
		@driver.manage.timeouts.implicit_wait = 20
		begin
			@driver.get(@url)
		rescue Timeout::Error
			puts "Rescued exception"
		end
	end

	# def scrape
 #        get_elements
	# end


	# def set_pagination_method method, target = nil
	# 	case method
	# 		when "click"
	# 			# self.load_next_page_method = click_next_page target 
	# 			@get_elements = :scrape_for_clickable_next_page
	# 		when "scroll"
	# 			# self.load_next_page_method = scroll_to_bottom
	# 			@get_elements = :scrape_for_infinite_scroll
	# 		else
	# 			raise Exception
	# 	end
	# 	self
	# end

	# def click_next_page target
	# 	click(target)
	# end

	# def scroll_to_bottom
	# 	execute_script("window.scrollTo(0, document.body.scrollHeight);")
	# end

	def scrape_for_infinite_scroll
		last_height = @driver.execute_script("return document.body.scrollHeight")
		new_height = nil
		# page_size = @driver.
		begin
			puts "last height was #{last_height}"
			last_height = new_height || last_height
			@driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
			new_height = @driver.execute_script("return document.body.scrollHeight")
			sleep(20)
		end while new_height != last_height
		elements = Nokogiri::HTML(@driver.page_source).css(@css_class)
		elements
	end
end