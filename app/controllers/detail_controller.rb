class DetailController < ApplicationController
    def index
        @pageLocation = ["Search", "Detail"]

        serverInteraction = ConnectionTracker.get(session.id)

        @input = params[:input]
        @assessmentID = params[:assessment]
        questionnaire = serverInteraction.getSpecificResource(FHIR::Questionnaire, @assessmentID)
        @item = helpers.getItemByID(questionnaire, params[:id])

        
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
        

        @assessmentName = (@qssActive + @qssInactive).select{ |qs| qs[:id].eql?(@assessmentID) }.first[:name]
    end
end
