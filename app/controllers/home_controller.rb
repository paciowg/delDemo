class HomeController < ApplicationController
    def index
        @qssActive = Array.new
        @qssInactive = Array.new
        ServerInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
            qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
        end

        SessionStack.delete(session.id)
    end
end
