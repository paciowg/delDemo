class QuestionnaireController < ApplicationController
  def index
    @questionnaire = GetQuestionnaires.getQuestionnaire(params[:version])
    @currentSection = nil
    if params[:page].nil?
      @currentSection = 1
    elsif params[:page][0..3].eql?("back")
      @currentSection = params[:page].split(",").last.to_i
      session.delete(@currentSection.to_s)
    elsif params[:page].eql?("submit")
      # submit logic (render submission page, finish )
      session["last"] = helpers.getRelevantParams(params)
      render 'submission'
    else
      @currentSection = params[:page].to_i
      session[(@currentSection - 1).to_s] = helpers.getRelevantParams(params)
    end

    puts session

    if @questionnaire.nil?
      render 'questionnaire/error'
    end
  end
end
