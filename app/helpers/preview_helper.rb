module PreviewHelper

    def constructAssessment(sessionID, quest)
        qSects = getSectionedQuestionnaire(quest)
        currentLevel = 0
        sesh = SessionStack.qRead(sessionID)

        assessment = FHIR::QuestionnaireResponse.new
        assessment.status = "in-progress"
        assessment.questionnaire = quest.url
        assessment.subject = FHIR::Reference.new
        assessment.subject.type = "Questionnaire"
        assessment.text = FHIR::Narrative.new
        assessment.text.status = "generated"
        assessment.text.div = '<div xmlns=\"http://www.w3.org/1999/xhtml\">Questionnaire response from the DEL Demo Client.</div>'

        timeStr = Time.now.to_s.gsub(" ", "");
        assessment.authored = timeStr[0..9] + "T" + timeStr[10..-3] + ":" + timeStr[-2..-1]

        qSects.each_with_index do |qSect, page|
            assessment.item.push(FHIR::QuestionnaireResponse::Item.new)
            assessment.item[-1] = qrPopulateItem(assessment.item.last, sesh, qSect, page + 1)
        end

        assessment
    end

    def qrPopulateItem(item, sesh, qSect, page, index = 0)
        item.text = qSect[index].item.text
        item.linkId = qSect[index].item.linkId
    
        itemSeshKeys = (sesh[page] ? sesh[page].keys.select{ |key| key.eql?(item.linkId) || key.include?(item.linkId + "-") } : [])
        if !itemSeshKeys.empty? && !qSect[index].item.type.end_with?("display", "group")

            answers = itemSeshKeys.collect{ |key| sesh[page][key] }
            if itemSeshKeys.any?{ |k| k.end_with?("--m", "--d", "--y") }
                metaDate = sesh[page][qSect[index].item.linkId]
                if metaDate
                    answers = [metaDate.eql?("date") ? answers[1..-1].collect{ |a| (a.length == 1 ? "0" + a : a) }.join : metaDate]
                else
                    answers = [answers.collect{ |a| (a.length == 1 ? "0" + a : a) }.join]
                end
            end

            answers.each do |answer|
                if qSect[index].item.type.eql?("integer")
                    item.answer.push(FHIR::QuestionnaireResponse::Item::Answer.new({valueInteger: answer.to_i}))
                elsif qSect[index].item.type.eql?("decimal")
                    item.answer.push(FHIR::QuestionnaireResponse::Item::Answer.new({valueDecimal: answer.to_f}))
                else
                    if !qSect[index].item.answerOption.empty?
                        answerCoding = qSect[index].item.answerOption.find{ |code| code.valueCoding.code.eql?(answer) } 
                        if answerCoding
                            item.answer.push(answerCoding)
                        else
                            item.answer.push(FHIR::QuestionnaireResponse::Item::Answer.new({valueString: answer}))
                        end
                    else
                        item.answer.push(FHIR::QuestionnaireResponse::Item::Answer.new({valueString: answer}))
                    end
                end
            end
        end

        newIndex = index + 1
        currentLevel = qSect[index].level
        while qSect[newIndex] && qSect[newIndex].level > currentLevel
            if qSect[newIndex].level == currentLevel + 1
                item.item.push(FHIR::QuestionnaireResponse::Item.new)
                qrPopulateItem(item.item.last, sesh, qSect, page, newIndex)
            end
            newIndex += 1
        end

        item
    end

    def qrDisplay(qr)
        getSectionedQuestionnaire(qr)
    end

end
