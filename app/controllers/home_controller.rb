class HomeController < ApplicationController
  def index
    @questionnaireHash = GetQuestionnaires.getAllQuestionnaires()

    SessionStack.delete(session.id)

    if @questionnaireHash.nil?
      render 'home/error'
    elsif @questionnaireHash.eql?('no_entry')
      render 'home/read_error'
    end
  end
end
