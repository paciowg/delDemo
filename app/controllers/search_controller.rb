class SearchController < ApplicationController
    def index
        unfilteredQs = ServerInteraction.search(FHIR::Questionnaire, params[:input])
        @qs = helpers.searchItems(unfilteredQs, params[:input])
    end
end
