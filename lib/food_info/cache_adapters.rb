require "food_info/cache_adapters/default"
require "food_info/cache_adapters/mem_cache_compatible"

module FoodInfo
  # All FoodInfo CacheAdapters must expose two public methods, +set+ and +get+, and will need to
  # behave compatibly with the memcache API.
  module CacheAdapters
  end
end