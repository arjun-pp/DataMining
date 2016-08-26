module Place
  class Location
    belongs_to :city
    has_one :location_type
  end
end