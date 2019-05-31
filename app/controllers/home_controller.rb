class HomeController < ApplicationController
  def index
    @questionnaireHash = GetQuestionnaires.getAllQuestionnaires()
  end
end
