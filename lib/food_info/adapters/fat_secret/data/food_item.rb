module FoodInfo
  module Adapters
    class FatSecret
      module Data
      
        class FoodItem < Hashie::Trash
          property :servings
          property :id,    :from => :food_id
          property :name,  :from => :food_name
          property :kind,  :from => :food_type
          property :url,   :from => :food_url
          property :brand, :from => :brand_name

          def initialize(*args)
            super(*args)
            self[:servings] = self[:servings]['serving'].collect{|s| FoodServing.new(s) }
          end
        end
      
      end
    end
  end
end