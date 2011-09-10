module FoodInfo
  module Adapters
    class FatSecret
      module Data
    
        class SearchResults < Hashie::Trash
          property :results,  :from => :food
          property :page,     :from => :page_number
          property :per_page, :from => :max_results
          property :total_results
      
          def initialize(*args)
            super(*args)
            normalize_data
          end
          
          def normalize_data
            [:page, :per_page, :total_results].each do |n|
              self[n] = self[n].to_i
            end
            
            self[:page] += 1 # FatSecret indexes their pages from 0
            self[:results] = [self[:results]] unless self[:results].is_a?(Array)
            self[:results] = (self[:results] || []).collect {|result| SearchResult.new(result) }
          end
        end
    
      end
    end
  end
end