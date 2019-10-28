class HomeController < ApplicationController
    def index
        SessionStack.create(session.id)

        # Satisfies requirements for search partial
        @assessmentID = nil

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
