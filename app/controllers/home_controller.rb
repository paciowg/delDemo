OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require 'json'

class HomeController < ApplicationController
  def index
    @url = "https://impact-fhir.mitre.org/r4/"
    @client = FHIR::Client.new(@url)
    FHIR::Model.client = @client
    allQuestionnaires = @client.read_feed(FHIR::Questionnaire) # fetch Bundle of Questionnaires
    json = allQuestionnaires.response.values[2]
    questionnaireHash = JSON.parse(json)
  end
end
