class PreviewController < ApplicationController
  def index
    @version = SessionStack.qRead(session.id)[1]["version"]
    @questionnaire = ServerInteraction.getQuestionnaire(@version)

    @assessment = helpers.constructAssessment(session.id, @questionnaire)

    SessionStack.qrPush(session.id, @assessment)
  end
end
