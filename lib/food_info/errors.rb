module FoodInfo
  class NoAdapterSpecified < StandardError; end
  class UnsupportedAdapter < StandardError; end
  class AuthorizationError < StandardError; end
  class DataSourceException < StandardError; end
end