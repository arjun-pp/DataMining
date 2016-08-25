class GoogleAddress
	def initialize
		@geocoder_api_key = " AIzaSyAoDy2PTmuO3-_R4Njw7rXIR6tK0ES7ZKg"
		@geocoder_api_url = "https://maps.googleapis.com/maps/api/geocode/json?address=%s"
	end

	def get_clean_address address
		uri = URI(@geocoder_api_url % [address])
		response = JSON.parse(Net::HTTP.get(uri))
		process_address response["results"][0]
	end

	def handle_insertion address, address_location_type = ""
		clean_address = get_clean_address address
		insert_address clean_address, address_location_type
	end

	def process_address api_data
		address = {}
		for component in api_data["address_components"].reverse do
			if component["types"].include? "locality"
				address["city"] = component["long_name"]
			end

			if component["types"].include? "sublocality_level_1" and address.fetch("city", nil)
				address["sector"] = component["long_name"]		
				address["type"] = "sector"		
			end			

			if component["types"].include? "sublocality_level_2" and address.fetch("sector", nil)
				address["area"] = component["long_name"]		
				address["type"] = "area"		
			end			

			if component["types"].include? "sublocality_level_3" and address.fetch("area", nil)
				address["neghbourhood"] = component["long_name"]		
				address["type"] = "neghbourhood"		
			end			

			if component["types"].to_set.intersect?(["premise", "establishment", "point_of_interest"].to_set)
				address["location"] = component["long_name"]		
				address["type"] = "location"		
			end
		end
		address["coordinates"] = api_data["geometry"]["location"]
		address
	end

	def insert_address address, address_location_type
		if not Place::City.new(address["city"]).exists?
			insert_city address
		end

		if address["sector"].exists? and not Place::City.new(address["city"]).sector(address["sector"]).exists?
			insert_sector address
		end

		if address["area"].exists? and not Place::City.new(address["city"]).sector(address["sector"]).area(address["area"]).exists?
			insert_area address
		end

		if address["neghbourhood"].exists? and not Place::City.new(address["city"]).sector(address["sector"]).area(address["area"]).neghbourhood(address["neghbourhood"]).exists?
			insert_neighbourhood address
		end
		if address["locality"].exists? 
			insert_location address, address_location_type
		end
	end

	def insert_city address
		if address["type"] == "city"
			coordinates = adress["coordinates"] 
		else
			get_coordinates address.fetch("city")
		end	
		Place::City.new(:name => address["city"], :lat => coordinates["lat"], :lng => coordinates["lng"])
			.save!
	end

	def insert_sector address
		if address["type"] == "sector"
			coordinates = adress["coordinates"] 
		else
			coordinates = get_coordinates address.fetch("sector") + address.fetch("city")
		end
		Place::City.new(:name => address["city"])
			.sector(:name => address["sector"], :lat => coordinates["lat"], :lng => coordinates["lng"])
			.save!
	end	

	def insert_area address
		if address["type"] == "area"
			coordinates = adress["coordinates"] 	
		else
			coordinates = get_coordinates address.fetch("area") + address.fetch("sector", "") + address.fetch("city")
		end
		Place::City.new(:name => address["city"])
			.sector(:name => address["sector"])
			.area(:name => address["area"], :lat => coordinates["lat"], :lng => coordinates["lng"])
			.save!
	end	

	def insert_neighbourhood address
		if address["type"] == "neighbourhood"
			coordinates = adress["coordinates"] 
		else
			coordinates = get_coordinates address.fetch("neghbourhood") + address.fetch("area", "") + address.fetch("sector", "") + address.fetch("city")
		end
		Place::City.new(:name => address["city"])
			.sector(:name => address["sector"])
			.area(:name => address["area"])
			.neghbourhood(:name => address["neghbourhood"], :lat => coordinates["lat"], :lng => coordinates["lng"])
			.save!
	end	

	def insert_location address, address_location_type
		coordinates = adress["coordinates"]
		if address_location_type
			Place::City.new(:name => address["city"])
				.location(:name => address["neghbourhood"], :lat => coordinates["lat"], :lng => coordinates["lng"])
				.address_location_type(:name => address_location_type)
				.save!
		else
			Place::City.new(:name => address["city"])
				.location(:name => address["neghbourhood"], :lat => coordinates["lat"], :lng => coordinates["lng"])
				.save!
		end
	end	

	def extract_coordinates api_data
		api_data["geometry"]["location"]
	end

	def get_coordinates place
		api_data = get_google_address_data place
		extract_coordinates api_data 
	end
end