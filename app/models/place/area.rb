module Place
  class Area
    belongs_to :sector
    has_many :place_neighbourhoods, :class_name => 'Place::Neighbourhood'
  end
end