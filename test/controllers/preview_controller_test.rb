require 'test_helper'

class PreviewControllerTest < ActionDispatch::IntegrationTest
  test "should get preview" do
    get preview_preview_url
    assert_response :success
  end

end
