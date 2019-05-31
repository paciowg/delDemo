class QuestionnaireController < ApplicationController
  def index
    @oldQuestionnaire = GetQuestionnaires.getOldQuestionnaire()
    @questionnaire = GetQuestionnaires.getQuestionnaire(params[:version])
    @currentSection = nil
  end
end
