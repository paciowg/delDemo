class QuestionnaireController < ApplicationController

    helper ValidationHelper

    def index
        @pageLocation = ["Questionnaire"]

        serverInteraction = ConnectionTracker.get(session.id)

        @questionnaire = serverInteraction.getSpecificResource(FHIR::Questionnaire, params[:version])
        @questionnaireStatus = @questionnaire.status

        @currentSection = nil

        if params[:page].nil? && params[:back].nil?
            @currentSection = 1
            SessionStack.create(session.id, params[:loinc].eql?("true"))
        else
            @currentSection = (params[:page] ? params[:page].to_i : (params[:back] ? params[:back].to_i : 1))
            SessionStack.push(session.id, helpers.getRelevantParams(params))
            redirect_to url_for(controller: "preview", action: "index") if params[:page] && params[:page].include?("preview")
        end

        @loinc = SessionStack.loinc?(session.id)

        @filledSections = SessionStack.qLength(session.id)

        if @questionnaire.nil?
            render '/questionnaire/error'
        end
    end
end
