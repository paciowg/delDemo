class PreviewController < ApplicationController
  def index
    @questionnaire = GetQuestionnaires.getQuestionnaire(SessionStack.read(session.id)[1]["version"])

    @tempForPreviewDev = SessionStack.read(session.id)

    @assessment = helpers.constructAssessment(session.id, @questionnaire)
  end
end
