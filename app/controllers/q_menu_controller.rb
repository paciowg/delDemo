# This will never be reached
# TODO: Delete upon release if team doesn't want to revert

class QMenuController < ApplicationController
  def index
    @questionnaireVersions = GetQuestionnaires.getQuestionnaireVersions()
  
    SessionStack.delete(session.id)
  
    if @questionnaireVersions.empty?
      render 'home/error'
    end
  end
end
