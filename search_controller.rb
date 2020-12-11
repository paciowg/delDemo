class SearchController < ApplicationController
    def index
        @pageLocation = ["Search"]

        serverInteraction = ConnectionTracker.get(session.id)

        @input = params[:input]
        @assessmentID = params[:assessment]
        searchKey = @assessmentID + "--" + @input
        @page = params[:page].blank? ? 1 : params[:page].to_i

        unless SessionStack.searchRead(session.id)[0].eql?(searchKey)
            unless @input.blank? && @assessmentID.blank?
                unfilteredQs = serverInteraction.search(FHIR::Questionnaire, @input, @assessmentID)
            end
            SessionStack.searchPush(session.id, [searchKey, helpers.searchItems(unfilteredQs, @input)])
        end
        search = SessionStack.searchRead(session.id)[1]
        @qsTotalSize = search[0]
        @pageUpperBound = search[1].length
        @qs = search[1][@page - 1]

        qss = SessionStack.qSummariesRead(session.id)
        if qss[:active].nil? && qss[:inactive].nil?
            @qssActive = Array.new
            @qssInactive = Array.new
            serverInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
                qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
            end
            SessionStack.qSummariesPush(session.id, @qssActive, @qssInactive)
        else
            @qssActive = qss[:active]
            @qssInactive = qss[:inactive]
        end
    end
end
