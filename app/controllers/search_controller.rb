class SearchController < ApplicationController
    def index
        @input = params[:input]
        unfilteredQs = ServerInteraction.search(FHIR::Questionnaire, @input)
        @qs = helpers.searchItems(unfilteredQs, @input)

        @qssActive = Array.new
        @qssInactive = Array.new
        ServerInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
            qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
        end
    end
end
