class SubmissionController < ApplicationController

    def index
        @pageLocation = ["Questionnaire", "Preview", "Submission"]

        @questionnaireStatus = "active"
    end

    def download
        return nil unless params[:fileExt]
        @assessment = Submission.submitAssessment(SessionStack.qrRead(session.id))
        name = Time.now.to_s[0..-7].gsub(" ", "_") + "_del_assessment." + params[:fileExt]
        send_data(
            (params[:fileExt].eql?("json") ? @assessment.to_json : @assessment.to_xml),
            type: (params[:fileExt].eql?("json") ? :json : :xml),
            filename: name,
            disposition: 'attachment'
        )
    end

end
