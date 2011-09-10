require 'httparty'

module FoodInfo
  module Sources
    module FatSecret
  
      class API
        include HTTParty
    
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
  end
end