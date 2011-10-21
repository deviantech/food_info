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
      RETRY_INVALID_TIMESTAMP = 1 # Only retry once to avoid huge pileup if concurrent
      
      def initialize(opts = {})
        raise AuthorizationError.new("Missing required argument :key")    unless @key    = opts[:key]
        raise AuthorizationError.new("Missing required argument :secret") unless @secret = opts[:secret]
      end

      def search(q, opts = {})
        params = {
          :search_expression => q,
          :page_number => opts[:page] || 1,
          :max_results => opts[:per_page] || 20
        }
        params[:page_number] = [params[:page_number].to_i - 1, 0].max # FatSecret's pagination starts at 0
        params[:max_results] = [params[:max_results].to_i, 50].min    # FatSecret's max allowed results per page
                
        data = query('foods.search', params)
        Data::SearchResults.new( data['foods'] )
      end
  
      def details(food_id, opts = {})
        data = query('food.get', :food_id => food_id)
        Data::FoodItem.new( data['food'] )
      end
  
      protected
  
      def query(method, opts = {}, retried = 0)
        query_url = Request.new(method, {:key => @key, :secret => @secret}, opts).signed_request
        data = self.class.get( query_url )
        
        if data['error']  # Invalid timestamp can happen if more than one request/second. Allow retrying once.
          if data['error']['message'] =~ 'Invalid/expired timestamp' && retried < RETRY_INVALID_TIMESTAMP
            return query(method, opts, retried + 1)
          else
            raise DataSourceException.new(data['error']['message'])
          end
        end
      
        return data
      end
      
    end
  end
end