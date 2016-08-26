class Scraper
  # all params are string
  def initialize(url, css_class, pagination_css='', selected_page_css = '')
    @url = url
    @css_class= css_class
    @pagination_css = pagination_css
    @selected_page_css = selected_page_css
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.timeouts.implicit_wait = 20
    @domain = URI.parse(@url).host
    @scraper_db = Daybreak::DB.new "scraper.db"
    begin
      puts 'Fetching URL'
      @driver.get(@url)
    rescue Timeout::Error
      puts "Rescued exception"
    end
  end

  # def scroll_to_bottom
  # 	execute_script("window.scrollTo(0, document.body.scrollHeight);")
  # end

  def scrape_for_infinite_scroll
    puts 'Starting scrolling scraping'
    last_height = @driver.execute_script("return document.body.scrollHeight")
    new_height = nil
    # page_size = @driver.
    begin
      puts "last height was #{last_height}"
      last_height = new_height
      @driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
      @driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
      new_height = @driver.execute_script("return document.body.scrollHeight")
      puts new_height
      wait_for_ajax
      sleep(100)
    end while new_height != last_height
    elements = Nokogiri::HTML(@driver.page_source).css(@css_class)
    puts elements
    Resque.enqueue(NeighborhoodWorker, elements, @domain)
    elements
  end

  # Inserts data into queue.(tested for 99acres)
  def scrape_for_pagination
    @scraper_db.set!("class:#{@url}", @css_class)
    puts 'Start pagination'
    next_page_found = true
    # Check for flags exists in daybreak
    if not @scraper_db["page:#{@url}"].nil?
      @driver.get(@scraper_db["page:#{@url}"])
    end
    while next_page_found
      page_html = Nokogiri::HTML(@driver.page_source)
      pagination_elements = page_html.css(@pagination_css)
      selected_page_element = page_html.css(@selected_page_css)
      next_page_found = false
      pagination_elements.each do |pagination_element|
        pagination_number = pagination_element.xpath('text()')[0].text.to_i
        selected_page_number = selected_page_element.xpath('text()')[0].text.to_i
        if pagination_number.equal?(selected_page_number + 1)
          @driver.get(@domain + pagination_element['href']) # May change for other sites
          @scraper_db.set!("page:#{@url}", @domain + pagination_element['href']) # ""
          next_page_found = true
          break
        end
      end
      elements = Nokogiri::HTML(@driver.page_source).css(@css_class)
      puts elements

      Resque.enqueue(NeighborhoodWorker, elements, @domain)
    end

  end

  def wait_for_ajax
    while true do
      ajax_complete = @driver.execute_script('return jQuery.Active == 0')
      if ajax_complete
        break
      end
      sleep(100)
    end
  end
end
