class SearchController < ApplicationController
    def index
        @measures = ServerInteraction.searchMeasures(params[:input])
    end
end
