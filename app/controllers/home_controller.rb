class HomeController < ApplicationController
    def index
        serverInteraction = ConnectionTracker.get(session.id)

        @qssActive = Array.new
        @qssInactive = Array.new
        serverInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
            qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
        end

        SessionStack.delete(session.id)
    end
end
