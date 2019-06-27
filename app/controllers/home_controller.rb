class HomeController < ApplicationController
  def index
    @questionnaires = GetQuestionnaires.getAllQuestionnaires()

    SessionStack.delete(session.id)

    if @questionnaires.nil?
      render 'home/error'
    elsif @questionnaires.eql?('no_entry')
      render 'home/read_error'
    end
  end
end
