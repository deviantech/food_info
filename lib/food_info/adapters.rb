require "food_info/adapters/fat_secret"

module FoodInfo
  # All FoodInfo adapters must expose two public methods, +search+ and +details+, and will need to
  # define their own classes to return data in a unified manner consistent with that laid out by
  # the existing FatSecret adapter's <tt>search_results</tt>, <tt>search_result</tt>, and <tt>details</tt> classes.
  module Adapters
  end
end