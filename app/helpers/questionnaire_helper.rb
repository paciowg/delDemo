module QuestionnaireHelper
    def flattenQuestionnaire(q)
        qFlat = [].append(getItem(q["resource"]["item"]))
        qFlat.flatten()
    end

    def getItem(itemArray, level=0)
        items = []
        return nil if itemArray.nil?
        itemArray.each do |item|
            items.append(QItem.new(item, level))
            if item.has_key?("item")
                items.append(getItem(item["item"], level + 1))
            end
        end
        items
    end

    def getOptions(item) #Returns array of 2 element arrays, like [[display, code], [display, code]]
        incArr = item["answerValueSet"]["compose"]["include"]
        concepts = []
        options= []
        incArr.each { |inc|
            concepts.append(inc["concept"])
        }
        concepts.each { |concept|
            options.append([concept["display"], concept["code"]])
        }
        options
    end
end
