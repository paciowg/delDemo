class HomeController < ApplicationController
  def index
    @questionnaireVersions = GetQuestionnaires.getQuestionnaireVersions()
  end
end
