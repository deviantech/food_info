require 'delegate'

require "food_info/utils"
require "food_info/version"
require "food_info/sources/fat_secret/request"
require "food_info/sources/fat_secret/api"

module FoodInfo
  # Allow extending to additional data sources in the future
  # Each source should implement +search+ and +details+ methods.
  AVAILABLE_SOURCES = [FoodInfo::Sources::FatSecret::API]
  
  # Set default source
  @source = AVAILABLE_SOURCES.first.new

  class << self
    
    # Searches the current data source
    def search(q)
      @source.search(q)
    end
    
    def details(id)
      @source.details(id)
    end
    
    # Sets the source to connect to for data. 
    # e.g. passing <tt>:fat_secret</tt> sets source to <tt>FoodInfo::Sources::FatSecret::API</tt>
    def source=(src)
      klass_name = src.to_s.downcase.split('_').map(&:capitalize).join
      klass = AVAILABLE_SOURCES.detect{|k| k.name.eql?("FoodInfo::Sources::#{klass_name}::API") }
      @source = klass.new if klass
    end
  end
end


__END__

FoodInfo.search('cheese')
FoodInfo.source = :fat_secret
FoodInfo.search('cheese')
FoodInfo.details(id)


constant = Object
names.each do |name|
  constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
