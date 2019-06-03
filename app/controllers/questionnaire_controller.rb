class QuestionnaireController < ApplicationController
  def index
    @oldQuestionnaire = GetQuestionnaires.getOldQuestionnaire()
    @questionnaire = GetQuestionnaires.getQuestionnaire(params[:version])
    @currentSection = nil
    if @questionnaire.nil?
      render 'questionnaire/error'
    end
  end
end
