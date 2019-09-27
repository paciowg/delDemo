class HomeController < ApplicationController
    def index
        questionnaireVersions = GetQuestionnaires.getQuestionnaireVersions()
        @activeVersions = Array.new
        @inactiveVersions = Array.new
        questionnaireVersions.each do |qv|
            qv[:status].eql?("active") ? @activeVersions.append(qv) : @inactiveVersions.append(qv)
        end
        SessionStack.delete(session.id)
    end
end
