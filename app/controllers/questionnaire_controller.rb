class QuestionnaireController < ApplicationController
  def index
    @questionnaire = GetQuestionnaires.getQuestionnaire(params[:version])

    @currentSection = nil

    if params[:page].nil?
      @currentSection = 1
      SessionStack.create(session.id)

    elsif params[:page][0..3].eql?("back")
      @currentSection = params[:page].split(",").last.to_i
      SessionStack.pop(session.id)

    elsif params[:page].eql?("submit")
      # submit logic (render submission page, finish )
      SessionStack.push(session.id, helpers.getRelevantParams(params))
      redirect_to url_for(controller: "submission", action: "index")
      
    else
      @currentSection = params[:page].to_i
      SessionStack.push(session.id, helpers.getRelevantParams(params))
    end

    if @questionnaire.nil?
      render '/questionnaire/error'
    end
  end
end
