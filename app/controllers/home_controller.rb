class HomeController < ApplicationController
  def index
    @url = "impact-fhir.mitre.org"
    @client = FHIR::Client.new(@url)
    FHIR::Model.client = @client
    @assessments = GetAssessments.getAssessments()
    @currentSection = nil
  end
end
