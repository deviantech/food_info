require 'test_helper'

class FatSecretTest < Minitest::Test
  
  def setup
    FoodInfo.establish_connection(:fat_secret, :key => ENV['FS_KEY'], :secret => ENV['FS_SECRET'])
  end
  
  def test_retreives_details
    f = FoodInfo.details("33689")
    assert_equal "Cheddar Cheese", f.name
  end
  
end
