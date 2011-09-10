require 'httparty'

module FoodInfo
  
  class API
    include HTTParty
    format :json
    
    def self.search(q)
      get( Request.new('foods.search', :search_expression => q).signed_request )
    end
    
    def self.details(food_id)
      get( Request.new('food.get', :food_id => food_id).signed_request )
    end
  end
  
end