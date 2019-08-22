class QuestionnaireController < ApplicationController

  helper ValidationHelper

  def index
    @questionnaire = GetQuestionnaires.getQuestionnaire(params[:version])

    @currentSection = nil

    if params[:page].nil? && params[:back].nil?
      @currentSection = 1
      SessionStack.create(session.id)

    elsif params[:page].eql?("submit")
      # submit logic (render submission page, finish )
      SessionStack.push(session.id, helpers.getRelevantParams(params))
      redirect_to url_for(controller: "preview", action: "index")

    else
      @currentSection = (params[:page] ? params[:page].to_i : (params[:back] ? params[:back].to_i : 1))
      SessionStack.push(session.id, helpers.getRelevantParams(params))
    end

    if @questionnaire.nil?
      render '/questionnaire/error'
    end
  end
end
