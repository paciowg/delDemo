class Submission
    def self.submitAssessment(assessment)
        assessment.status = "completed"
        assessment
    end
end
