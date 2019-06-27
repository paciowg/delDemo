module QuestionnaireHelper
    def getSectionedQuestionnaire(q)
        qFlat = flattenQuestionnaire(q)
        qSections = []
        lastRoot = 0
        qFlat.each_with_index do |qItem, i|
            if qItem.level == 0 && i != 0
                qSections.push(qFlat[lastRoot..(i - 1)])
                lastRoot = i
            end
        end
        qSections.push(qFlat[lastRoot..qFlat.length])
        qSections
    end

    # returns the requested page along with a number representing how many pages there are total
    def getPage(q, page)
        sectQ = getSectionedQuestionnaire(q)
        [sectQ[page - 1], sectQ.length]
    end
    
    def flattenQuestionnaire(q)
        qFlat = [].append(getItem(q.item))
        qFlat.flatten()
    end

    def getItem(itemArray, level=0)
        items = []
        return nil if itemArray.nil?
        itemArray.each do |item|
            items.append(QItem.new(item, level))
            if item.item
                items.append(getItem(item.item, level + 1))
            end
        end
        items
    end

    def getOptions(item) #Returns array of 2 element arrays, like [[display, code], [display, code]]
        options = item.answerOption
        options.collect{ |i| [i.valueCoding.display, i.valueCoding.code]}
    end

    def getRelevantParams(params)
        revisedParams = Hash.new
        avoidKeys = ["page", "utf8", "attempt", "controller", "action"]
        params.each_pair { |key, value|
            if !avoidKeys.include?(key)
                revisedParams[key] = value
            end
        }
        revisedParams
    end

    def questionnaireError()
        ApplicationController.render 'questionnaire/error'
    end

    def cleanLabel(label)
        label.gsub(/\{(P|p)atient\/(R|r)esident\}/, "\\1atient")
    end

    def prepopulate(id)
        sesh = SessionStack.read(session.id)
        sesh.each do |page|
            if page.has_key?(id)
                return page[id]
            end
        end
        return ""        
    end
end
