require 'hashie'

require "food_info/utils"
require "food_info/errors"
require "food_info/adapters"
require "food_info/version"


module FoodInfo
  
  # Allow extending to additional data sources in the future
  # Each adapter should implement +search+ and +details+ methods.
  ADAPTERS = {:fat_secret => FoodInfo::Adapters::FatSecret}
  
  class << self

    # Sets the adapter we'll be pulling data from.
    def establish_connection(adapter_name, opts = {})
      klass = ADAPTERS[adapter_name.to_sym]
      raise UnsupportedAdapter.new("Requested adapter ('#{adapter_name}') is unknown") unless klass
      @@pool = []
      @@cursor = 0
      (opts.delete(:pool) || 1).to_i.times do
        @@pool << klass.new(opts) 
      end
      
      true
    end

    def search(q, opts = {})
      next_adapter.search(q, opts)
    end
    
    def details(id)
      next_adapter.details(id)
    end


    # FUTURE: This connection pool code won't do much good until HTTParty is non-blocking
    def next_adapter
      raise NoAdapterSpecified.new("You must run FoodInfo.establish_connection first") unless @@pool
      @@cursor = (@@cursor + 1) % @@pool.length
      @@pool[@@cursor]
    end
    
  end
end


__END__

FoodInfo.establish_connection(:fat_secret, :key => ENV['KEY'], :secret => ENV['SECRET'])
a=FoodInfo.search('cheese', :page => 1, :per_page => 1).results.first
a=FoodInfo.search('cheese')

FoodInfo.establish_connection(:fat_secret, :key => ENV['KEY'], :secret => ENV['SECRET'])
a=FoodInfo.details("33689")
