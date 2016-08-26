module Place
  class City
    has_many :place_sectors, :class_name => 'Place::Sector'
    has_many :place_locations, :class_name => 'Place::Location'
  end
end