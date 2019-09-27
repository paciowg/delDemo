class HomeController < ApplicationController
    def index
        @qssActive = Array.new
        @qssInactive = Array.new
        ServerInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
            qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
        end

        @lssActive = Array.new
        @lssInactive = Array.new
        ServerInteraction.getSummaries(FHIR::Library).each do |qv|
            qv[:status].eql?("active") ? @lssActive.append(qv) : @lssInactive.append(qv)
        end

        SessionStack.delete(session.id)
    end
end
