class SearchController < ApplicationController
    def index
        @input = params[:input]
        unfilteredQs = ServerInteraction.search(FHIR::Questionnaire, @input)
        @qs = helpers.searchItems(unfilteredQs, @input)
    end
end
