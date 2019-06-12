class SubmissionController < ApplicationController
  def index
    @assessment = Submission.submitAssessment(SessionStack.read(session.id))
    SessionStack.delete(session.id)
    if @assessment.nil?
      render 'submission/error'
    end
  end
end
