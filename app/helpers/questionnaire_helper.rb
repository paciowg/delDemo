module QuestionnaireHelper
    def isQuestionActuallyLabel?(assessments, listIndex)
        id = assessments[listIndex]["Item ID"]
        section = assessments[listIndex]["Section Name"]
        isLabel = false
        if !section.include?("Section J") && !section.include?("Integumentary Status")
            isLabel = assessments.length > listIndex + 1 && assessments[listIndex+1]["Item ID"].include?(id)
        end
        return isLabel
    end
end
