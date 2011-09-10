module FoodInfo
  class Error < RuntimeError; end
  class InvalidAdapter < Error; end
  class AuthorizationError < Error; end
end