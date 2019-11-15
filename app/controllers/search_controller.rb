class SearchController < ApplicationController
    def index
        @pageLocation = ["Search"]

        serverInteraction = ConnectionTracker.get(session.id)

        @input = params[:input]
        @assessmentID = params[:assessment]
        unless @input.blank? && @assessmentID.blank?
            unfilteredQs = serverInteraction.search(FHIR::Questionnaire, @input, @assessmentID)
        end
        @qs = helpers.searchItems(unfilteredQs, @input)

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
