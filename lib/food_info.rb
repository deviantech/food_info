require "food_info/version"

require "food_info/utils"
require "food_info/errors"
require "food_info/adapters/fat_secret"

module FoodInfo
  
  # Allow extending to additional data sources in the future
  # Each adapter should implement +search+ and +details+ methods.
  ADAPTERS = {:fat_secret => FoodInfo::Adapters::FatSecret}
  
  class << self

    # Sets the adapter we'll be pulling data from.
    def establish_connection(adapter_name, opts = {})
      klass = ADAPTERS[adapter_name.to_sym]
      raise InvalidAdapter.new("Requested adapter ('#{adapter_name}') is unknown") unless klass
      @adapter = klass.new(opts)
    end
    
    
    # Searches the current data source
    def search(q)
      @adapter.search(q)
    end
    
    def details(id)
      @adapter.details(id)
    end
    
  end
end


__END__

FoodInfo.establish_connection(:fat_secret, :key => ENV['KEY'], :secret => ENV['SECRET'])
FoodInfo.search('cheese')
FoodInfo.details(id)

FoodInfo::Adapter.new(:fat_secret, opts)::FatSecret.new()