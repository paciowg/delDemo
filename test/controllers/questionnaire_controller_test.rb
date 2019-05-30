require 'test_helper'

class QuestionnaireControllerTest < ActionDispatch::IntegrationTest
  test "should get questionnaire" do
    get questionnaire_questionnaire_url
    assert_response :success
  end

end
