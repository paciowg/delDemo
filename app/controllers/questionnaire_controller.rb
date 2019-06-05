class QuestionnaireController < ApplicationController
  def index
    @questionnaire = GetQuestionnaires.getQuestionnaire(params[:version])
    @currentSection = nil
    if @questionnaire.nil?
      render 'questionnaire/error'
    end
  end
end
