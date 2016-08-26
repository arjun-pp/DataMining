

class NeighborhoodWorker
  @queue =  :neighborhood_update
  # @param elements [Array]
  # @param domain [String]
  def self.perform(elements, domain)
    elements.each do |element|
      if domain.equal?('www.99acres.com')
        neighbourhood = NinetyNineParser.get_neighbourhood(element)
      elsif domain.equal?('www.magicbricks.com')
        neighbourhood = MagicBricksParser.get_neighbourhood(element)
      end

    end
  end
end