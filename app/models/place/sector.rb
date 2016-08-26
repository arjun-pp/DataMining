module Place
  class Sector
    belongs_to :city
    has_many :place_areas, :class_name => 'Place::Area'
  end
end