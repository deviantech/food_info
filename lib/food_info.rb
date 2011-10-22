require 'hashie'

require "food_info/utils"
require "food_info/errors"
require "food_info/adapters"
require "food_info/cache_adapters"
require "food_info/version"


module FoodInfo
  
  # Allow extending to additional data sources in the future
  # Each adapter should implement +search+ and +details+ methods.
  ADAPTERS = {:fat_secret => FoodInfo::Adapters::FatSecret}
  
  class << self

    # Sets the adapter we'll be pulling data from.
    #
    # Example usage:
    #   FoodInfo.establish_connection(:fat_secret, :key => '...', :secret => '...')
    #
    # Example with cache:
    #   require 'dalli' # Use dalli gem to interface with memcache
    #   client = Dalli::Client.new('localhost:11211')
    #   FoodInfo.establish_connection(:fat_secret, :key => '...', :secret => '...', :cache => client)
    def establish_connection(adapter_name, opts = {})
      klass = ADAPTERS[adapter_name.to_sym]
      raise UnsupportedAdapter.new("Requested adapter ('#{adapter_name}') is unknown") unless klass
      
      # Set up the pool of workers (net yet implemented, so defaulting to "pool" of one)
      @@pool = []
      @@cursor = 0
      (opts.delete(:pool) || 1).to_i.times do
        @@pool << klass.new(opts) 
      end
      
      # Set up the cache, if any provided
      obj = opts.delete(:cache)
      @cache = obj ? FoodInfo::CacheAdapters::MemCacheCompatible.new(obj) : FoodInfo::CacheAdapters::Default.new
      
      true
    end

    # ======================
    # = Public API Methods =
    # ======================
    def search(q, opts = {})
      cached(:search, q, opts)
    end
    
    def details(id, opts = {})
      cached(:details, id)
    end


    # ==========================
    # = Implementation details =
    # ==========================
    def cached(method, param, opts = {})
      key = request_key(method, param, opts)
      
      @cache.get(key) || @cache.set(key, next_adapter.send(method, param, opts))
    end

    # FUTURE: This connection pool code won't do much good until HTTParty is non-blocking
    def next_adapter
      raise NoAdapterSpecified.new("You must run FoodInfo.establish_connection first") unless defined?(@@pool)
      @@cursor = (@@cursor + 1) % @@pool.length
      @@pool[@@cursor]
    end
    
    # Convert method + args into a string for use as the cache key
    def request_key(method, param, opts = {})
      # {:param => 123, :other => "something"} # => "other=something:param=123"
      str_opts = opts.sort{|a,b| a.to_s <=> b.to_s}.map{|pair| pair.join('=')}.join(':')
      
      "FoodInfo:#{method}:#{param}:#{str_opts}"
    end
    
  end
end


__END__

FoodInfo.establish_connection(:fat_secret, :key => ENV['KEY'], :secret => ENV['SECRET'])
a=FoodInfo.search('cheese', :page => 1, :per_page => 1).results.first
a=FoodInfo.search('cheese')

FoodInfo.establish_connection(:fat_secret, :key => ENV['KEY'], :secret => ENV['SECRET'])
a=FoodInfo.details("33689")
