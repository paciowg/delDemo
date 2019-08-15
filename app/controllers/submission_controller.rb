class SubmissionController < ApplicationController
  def index
    @assessment = Submission.submitAssessment(SessionStack.qrRead(session.id))

    SessionStack.delete(session.id)
    
    if @assessment.nil?
      render '/submission/error'
    end
  end
end
