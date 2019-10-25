class SearchController < ApplicationController
    def index
        serverInteraction = ConnectionTracker.get(session.id)

        @input = params[:input]
        @assessment = params[:assessment]
        unfilteredQs = serverInteraction.search(FHIR::Questionnaire, @input, @assessment)
        @qs = helpers.searchItems(unfilteredQs, @input)

        qss = SessionStack.qSummariesRead(session.id)
        if qss[:active].nil? && qss[:inactive].nil?
            serverInteraction = ConnectionTracker.get(session.id)
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
