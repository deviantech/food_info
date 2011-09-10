require 'httparty'

module FoodInfo
  
  class API
    include HTTParty
    format :json
    
    def search(q)
      query('foods.search', :search_expression => q)
    end
    
    def details(food_id)
      query('food.get', :food_id => food_id)
    end
    
    protected
    
    def query(method, opts = {})
      self.class.get( Request.new(method, opts).signed_request )
    end
  end
  
end