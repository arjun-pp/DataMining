require 'google_address'

class Housing
	def get_address poylgon_id
		housing_region_info_url = "https://regions.housing.com/api/v1/polygon/show/#{poylgon_id}"
		uri = URI(housing_region_info_url)
		response = JSON.parse(Net::HTTP.get(uri))
		housing_address = ""
		for place in response["breadcrumbs"][0] do
			housing_address += " " + place["name"] + " "
		end
		housing_address
	end

	def process_polygon_api
		db = Daybreak::DB.new "housing.db"
		File.open(Rails.root + "lib/housing_polygons.txt", "r") do |f|
			f.each_line do |poylgon_id|
				poylgon_id.strip!
				print "Processing %s" % [poylgon_id]
				if not (db.keys.include? poylgon_id and db[poylgon_id] == "done")
						housing_address = get_address poylgon_id
						GoogleAddress.new.handle_insertion housing_address
				    db.set! poylgon_id, "done"
				end
			end
		end
	end
end