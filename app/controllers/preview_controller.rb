class PreviewController < ApplicationController
    def index
        serverInteraction = ConnectionTracker.get(session.id)

        @version = SessionStack.qRead(session.id)[1]["version"]
        @questionnaire = serverInteraction.getSpecificResource(FHIR::Questionnaire, @version)

        @assessment = helpers.constructAssessment(session.id, @questionnaire)

        SessionStack.qrPush(session.id, @assessment)
    end
end
