module FoodInfo
  module Adapters
    class FatSecret
      module Data

        class SearchResult < Hashie::Trash
          property :id,    :from => :food_id
          property :name,  :from => :food_name
          property :kind,  :from => :food_type
          property :url,   :from => :food_url
          property :brand, :from => :brand_name
          property :description, :from => :food_description
        end

      end
    end
  end
end