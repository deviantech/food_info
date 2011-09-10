module FoodInfo
  module Adapters
    class FatSecret
      module Data
      
        class FoodServing < Hashie::Trash
          property :id, :from => :serving_id
          property :url, :from => :serving_url
          
          # These are strange from FatSecret, we'll set them as properties to get it by Hashie::Trash, then clean up after initialized
          property :metric_serving_amount     # => "132.000"
          property :metric_serving_unit       # => "g"
          property :serving_description       # => "1 cup, diced"
          property :measurement_description   # => "cup, diced"
          property :number_of_units           # => "1.000"
          
          # For all attributes expected, see http://platform.fatsecret.com/api/Default.aspx?screen=rapiref&method=food.get
          DECIMALS = %w(calories carbohydrate protein fat saturated_fat polyunsaturated_fat monounsaturated_fat trans_fat cholesterol sodium potassium fiber sugar)
          INTEGERS = %w(vitamin_a vitamin_c calcium iron)
          (DECIMALS + INTEGERS).each {|n| property(n) }

          def initialize(*args)
            super(*args)
            normalize_data
          end
          
          def normalize_data
            self[:metric_serving_amount] = self[:metric_serving_amount].to_f
            self[:number_of_units] = self[:number_of_units].to_f
            
            INTEGERS.each do |n|
              self[n.to_sym] = self[n.to_sym].to_i
            end

            DECIMALS.each do |n|
              self[n.to_sym] = self[n.to_sym].to_f
            end
          end
          
        end

      end
    end
  end
end