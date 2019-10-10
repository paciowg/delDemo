class DetailController < ApplicationController
    def index
        serverInteraction = ConnectionTracker.get(session.id)

        @input = params[:input]
        @assessment = params[:assessment]
        questionnaire = serverInteraction.getSpecificResource(FHIR::Questionnaire, @assessment)
        @item = helpers.getItemByID(questionnaire, params[:id])

        @qssActive = Array.new
        @qssInactive = Array.new
        serverInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
            qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
        end
    end
end
