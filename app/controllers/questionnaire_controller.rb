class QuestionnaireController < ApplicationController
  def questionnaire
    @assessments = GetAssessments.getAssessments()
    @currentSection = nil
  end
end
