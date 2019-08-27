class QMenuController < ApplicationController
  def index
    @questionnaireVersions = GetQuestionnaires.getQuestionnaireVersions()
  
    SessionStack.delete(session.id)
  
    if @questionnaireVersions.empty?
      render 'home/error'
    end
  end
end
