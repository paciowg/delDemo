require 'test_helper'

class SubmissionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get submission_index_url
    assert_response :success
  end

end
