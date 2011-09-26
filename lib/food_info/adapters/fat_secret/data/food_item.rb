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

            # Can't use Array(), as that turns internals of the hash into array pairs as well
            serving_info = self[:servings]['serving']
            serving_info = [serving_info] if serving_info.is_a?(Hash)
            self[:servings] = serving_info.collect{|s| FoodServing.new(s) }
          end
        end
      
      end
    end
  end
end