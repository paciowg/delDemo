class SearchController < ApplicationController
    def index
        @measures = ServerInteraction.searchMeasures(params[:input])
        @libraries = Hash.new
        ServerInteraction.getAllLibraries().each do |lib|
            @libraries["Library/" + lib.id] = lib
        end
    end
end
