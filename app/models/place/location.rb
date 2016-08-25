class Location  < Place
	belongs_to :neighbourhood
	has_one :type	
end