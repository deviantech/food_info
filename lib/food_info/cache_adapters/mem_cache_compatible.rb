module FoodInfo
  module CacheAdapters
    class MemCacheCompatible
      
      def initialize(obj = nil)
        if obj && obj.respond_to?(:get) && obj.respond_to?(:set)
          @cache = obj
        else
          raise "FoodInfo::CacheAdapters::MemCacheCompatible must be initialized with an object that responds to get and set (look into the Dalli gem)"
        end
      end
      
      def set(key, val)
        begin
          @cache.set(key, val)
        rescue Exception => e
          STDERR.puts e
        end
        val
      end

      def get(key)
        begin
          @cache.get(key)
        rescue Exception => e
          STDERR.puts e
        end
        
        nil
      end
      
    end
  end
end
