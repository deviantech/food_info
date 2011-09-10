require 'httparty'
require 'food_info/adapters/fat_secret/request'

module FoodInfo
  module Adapters
    class FatSecret
      include HTTParty
      
      def initialize(opts = {})
        raise AuthorizationError.new("Missing required argument :key")    unless @key    = opts[:key]
        raise AuthorizationError.new("Missing required argument :secret") unless @secret = opts[:secret]
      end

      def search(q)
        query('foods.search', :search_expression => q)
      end
  
      def details(food_id)
        query('food.get', :food_id => food_id)
      end
  
      protected
  
      def query(method, opts = {})
        query_url = Request.new(method, {:key => @key, :secret => @secret}, opts).signed_request
        self.class.get( query_url )
      end
      
    end
  end
end