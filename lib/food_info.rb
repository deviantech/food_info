require "food_info/version"

require 'hashie'

require "food_info/utils"
require "food_info/errors"
require "food_info/adapters"


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
      raise NoAdapterSpecified.new("You must run FoodInfo.establish_connection first") unless @adapter
      @adapter.search(q)
    end
    
    def details(id)
      raise NoAdapterSpecified.new("You must run FoodInfo.establish_connection first") unless @adapter
      @adapter.details(id)
    end
    
  end
end


__END__

FoodInfo.establish_connection(:fat_secret, :key => ENV['KEY'], :secret => ENV['SECRET'])
a=FoodInfo.search('cheese')

FoodInfo.establish_connection(:fat_secret, :key => ENV['KEY'], :secret => ENV['SECRET'])
a=FoodInfo.details("33689")
