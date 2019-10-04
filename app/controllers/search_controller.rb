class SearchController < ApplicationController
    def index
        serverInteraction = ConnectionTracker.get(session.id)

        @input = params[:input]
        @assessment = params[:assessment]
        unfilteredQs = serverInteraction.search(FHIR::Questionnaire, @input, @assessment)
        @qs = helpers.searchItems(unfilteredQs, @input)

        @qssActive = Array.new
        @qssInactive = Array.new
        serverInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
            qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
        end
    end
end
