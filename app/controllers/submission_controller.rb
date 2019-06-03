class SubmissionController < ApplicationController
  def index
    @params = params
    @assessment = Submission.submitAssessment(@params)
    if @assessment.nil?
      render 'submission/error'
    end
  end
end
