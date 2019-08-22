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

    # returns array of 2 element arrays, like [[display, code], [display, code]]
    def getRawOptions(item)
        item.answerOption.collect{ |i| [cleanText(i.valueCoding.display), i.valueCoding.code] }
    end

    # returns pruned array of 2 element arrays, like [[display, code], [display, code]]
    def pruneOptions(options)
        unwanted = ["Minimum value", "Maximum value", "MMDDYYYY", "MMYYYY", "YYYY"]
        options.select{ |option| !(unwanted.include?(option[0]) || unwanted.include?(option[1])) }
    end

    # returns pruned array of 2 element arrays, like [[display, code], [display, code]], first element is the default
    def getOrderedOptions(item)
        options = pruneOptions(getRawOptions(item))
        prepop = getFromSession(item.linkId)
        return options if prepop.empty?

        i = options.index{ |arr| arr[1].eql?(prepop) }
        return options unless i

        selected = options.delete_at(i)
        return options unless selected
        
        [selected] + options
    end

    def getRelevantParams(params)
        revisedParams = Hash.new
        avoidKeys = ["utf8", "attempt", "controller", "action"]
        params.each_pair { |key, value|
            unless avoidKeys.include?(key)
                revisedParams[key] = value
            end
        }
        revisedParams
    end

    def questionnaireError()
        ApplicationController.render 'questionnaire/error'
    end

    def cleanText(text)
        clean = text.gsub(/\{(P|p)atient(|'s)\/(R|r)esident(|'s)\}/, "\\1atient\\2")
        clean.gsub!(/\{facility\/setting\}/, "facility")
        #above are specific replacements, below is general cleaning for missed cases
        clean.gsub!(/\{([^\/]*)\/.*\}/, "\\1") #converts "{how/are/you}" to "how"
        clean.gsub(/\{(.*)\}/, "\\1") #converts "{hey}" to "hey"
    end

    def getFromSession(id)
        sesh = SessionStack.qRead(session.id)
        sesh.each do |page|
            if page.has_key?(id)
                return page[id]
            end
        end
        return ""
    end

end
