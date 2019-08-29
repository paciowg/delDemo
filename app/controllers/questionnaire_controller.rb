class QuestionnaireController < ApplicationController

  helper ValidationHelper

  def index
    @questionnaire = GetQuestionnaires.getQuestionnaire(params[:version])

    @currentSection = nil

    if params[:page].nil? && params[:back].nil?
      @currentSection = 1
      SessionStack.create(session.id)

    else
      @currentSection = (params[:page] ? params[:page].to_i : (params[:back] ? params[:back].to_i : 1))
      SessionStack.push(session.id, helpers.getRelevantParams(params))
      redirect_to url_for(controller: "preview", action: "index") if params[:page] && params[:page].include?("preview")
    end

    @filledSections = SessionStack.qLength(session.id)

    if @questionnaire.nil?
      render '/questionnaire/error'
    end
  end
end
