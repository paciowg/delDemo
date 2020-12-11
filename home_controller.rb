class HomeController < ApplicationController
    def index
        if SessionStack.nil?
            puts ("DEBUG: SessionStack nil, creating a new one.") # MLT: debug line. remove when fixed.
            SessionStack.create(session.id) # MLT: preserve the SessionStack if previously created.

            # Satisfies requirements for search partial
            @assessmentID = nil
        else
            puts ("DEBUG: SessionStack already created.")  # MLT: debug line. remove when fixed.
        end
        qss = SessionStack.qSummariesRead(session.id)
        if qss[:active].nil? && qss[:inactive].nil?
            serverInteraction = ConnectionTracker.get(session.id)
            @qssActive = Array.new
            @qssInactive = Array.new
            serverInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
                qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
            end
            @qssActive = @qssActive.sort{ |i, j| i[:id] <=> j[:id] }
            @qssInactive = @qssInactive.sort{ |i, j| i[:id] <=> j[:id] }
            SessionStack.qSummariesPush(session.id, @qssActive, @qssInactive)
        else
            @qssActive = qss[:active].sort{ |i, j| i[:id] <=> j[:id] }
            @qssInactive = qss[:inactive].sort{ |i, j| i[:id] <=> j[:id] }
        end

        @summaryHash = helpers.populateSummaryHash(@qssActive + @qssInactive)
    end
end
