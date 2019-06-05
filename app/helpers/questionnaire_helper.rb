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

    def flattenQuestionnaire(q)
        qFlat = [].append(getItem(q["item"]))
        qFlat.flatten()
    end

    def getItem(itemArray, level=0)
        items = []
        return nil if itemArray.nil?
        itemArray.each do |item|
            items.append(QItem(item, level))
            if item.any?{ |child| child.has_key?("item")}
                items.append(getItem(child["item"], level + 1))
            end
        end
        items
    end
end
