class HomeController < ApplicationController
  def index
    @questionnaireHash = GetQuestionnaires.getAllQuestionnaires()
    if @questionnaireHash.nil?
      render 'home/error'
    elsif @questionnaireHash.eql?('no_entry')
      render 'home/read_error'
    end
  end
end
