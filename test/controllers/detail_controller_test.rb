require 'test_helper'

class DetailControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get detail_index_url
    assert_response :success
  end

end
