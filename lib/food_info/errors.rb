module FoodInfo
  class NoAdapterSpecified < StandardError; end
  class UnsupportedAdapter < StandardError; end
  class AuthorizationError < StandardError; end
end