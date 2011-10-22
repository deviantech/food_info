module FoodInfo
  module CacheAdapters
    class Default
      
      def get(key)
        nil
      end

      def set(key, val)
        val
      end
      
    end
  end
end