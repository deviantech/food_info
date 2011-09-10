require 'httparty'
require 'food_info/adapters/fat_secret/request'
require 'food_info/adapters/fat_secret/data/search_result'
require 'food_info/adapters/fat_secret/data/search_results'
require 'food_info/adapters/fat_secret/data/food_item'
require 'food_info/adapters/fat_secret/data/food_serving'

module FoodInfo
  module Adapters
    class FatSecret
      include HTTParty
      
      def initialize(opts = {})
        raise AuthorizationError.new("Missing required argument :key")    unless @key    = opts[:key]
        raise AuthorizationError.new("Missing required argument :secret") unless @secret = opts[:secret]
      end

      def search(q)
        data = query('foods.search', :search_expression => q)
        Data::SearchResults.new( data['foods'] )
      end
  
      def details(food_id)
        data = query('food.get', :food_id => food_id)
        Data::FoodItem.new( data['food'] )
      end
  
      protected
  
      def query(method, opts = {})
        query_url = Request.new(method, {:key => @key, :secret => @secret}, opts).signed_request
        self.class.get( query_url )
      end
      
    end
  end
end