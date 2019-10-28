class PreviewController < ApplicationController
    def index
        @pageLocation = ["Questionnaire", "Preview"]

        serverInteraction = ConnectionTracker.get(session.id)

        @version = SessionStack.qRead(session.id)[1]["version"]
        @questionnaire = serverInteraction.getSpecificResource(FHIR::Questionnaire, @version)
        @questionnaireStatus = @questionnaire.status

        @assessment = helpers.constructAssessment(session.id, @questionnaire)

        SessionStack.qrPush(session.id, @assessment)
    end
end
