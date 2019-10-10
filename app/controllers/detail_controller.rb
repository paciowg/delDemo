class DetailController < ApplicationController
    def index
        serverInteraction = ConnectionTracker.get(session.id)

        @input = params[:input]
        @assessmentID = params[:assessment]
        questionnaire = serverInteraction.getSpecificResource(FHIR::Questionnaire, @assessmentID)
        @item = helpers.getItemByID(questionnaire, params[:id])

        @qssActive = Array.new
        @qssInactive = Array.new
        serverInteraction.getSummaries(FHIR::Questionnaire).each do |qv|
            qv[:status].eql?("active") ? @qssActive.append(qv) : @qssInactive.append(qv)
        end

        @assessmentName = (@qssActive + @qssInactive).select{ |qs| qs[:id].eql?(@assessmentID) }.first[:name]
    end
end
