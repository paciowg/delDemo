class HomeController < ApplicationController
  def index
    @questionnaireVersions = GetQuestionnaires.getQuestionnaireVersions()

    SessionStack.delete(session.id)
  end
end
