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
        item.answerOption.collect{ |i| [i.valueCoding.display, i.valueCoding.code] }
    end
    # returns pruned array of 2 element arrays, like [[display, code], [display, code]]
    def pruneOptions(options)
        unwanted = ["Minimum value", "Maximum value"]
        options.select{ |option| !unwanted.include?(option[0]) }
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
        avoidKeys = ["page", "utf8", "attempt", "controller", "action"]
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

    def cleanLabel(label)
        label.gsub(/\{(P|p)atient\/(R|r)esident\}/, "\\1atient")
    end

    def getFromSession(id)
        sesh = SessionStack.read(session.id)
        sesh.each do |page|
            if page.has_key?(id)
                return page[id]
            end
        end
        return ""
    end

    def getValidation(item)
        item.type.eql?("open-choice") ? validateOpen(item) : validateText()
    end

    def validateText()
        {regex: ".*\\S.*", message: "Must have a non-whitespace character"}
    end

    def validateOpen(item)
        options = getRawOptions(item)

        boundDisplays = ["Minimum value", "Maximum value"]
        intBounds = options.select{ |option| boundDisplays.include?(option[0]) }
        unless intBounds.empty?
            min = intBounds[0][1] < intBounds[1][1] ? intBounds[0][1] : intBounds[1][1]
            max = min == intBounds[0][1] ? intBounds[1][1] : intBounds[0][1]
            rangeReg = rangeRegex(min, max)[:regex]
            reg = optionsRegex([rangeReg, options.collect{ |option| option[1] }].flatten.compact)
            return {regex: reg, message: rangeReg[:message]}
        end

        dateDisplays = ["MMDDYYYY", "MMYYYY", "YYYY"]
        dateOptions = options.select{ |option| dateDisplays.include?(option[0]) }
        unless dateOptions.empty?
            month = rangeRegex(1, 12)
            day = rangeRegex(1, 31)
            year = rangeRegex(1900, Time.now.year)
            return {mr: month[:regex], mm: month[:message], 
                    dr: day[:regex], dm: day[:message],
                    yr: year[:regex], ym: year[:message]}
        end

        validateText()
    end

    def optionsRegex(codes)
        regex = "("
        codes.each do |code|
            regex = regex + code + "|"
        end
        regex[0..-2] + ")"
    end
    
    def rangeRegex(min, max) # not ideal, but consistent (all other authentication happens through regex)
        minMax = pruneMinMax(min, max)
        return nil unless minMax
        ranges = getRanges(minMax[:min], minMax[:max]).flatten.compact
        message = "Input must be integer between " + min.to_i.to_s + " and " + max.to_i.to_s + " (inclusive)"
        {regex: rangesToRegex(ranges), message: message}
    end

    def pruneMinMax(min, max)
        min = min.to_i.to_s
        max = max.to_i.to_s
        while max[0].eql?('0')
            max = max[1..-1]
        end
        while min.length < max.length
            min = "0" + min
        end
        {min: min, max: max}
    end

    def getRanges(min, max)
        return nil unless min.to_i <= max.to_i
        lastNonZero = min.rindex(/[^0]/)
        frontMatch = min[0].eql?(max[0])
        rangeMax = ""
        if frontMatch
            min.each_char.with_index do |digit, i|
                break if !digit.eql?(max[i]) && !min[0..-2].eql?(max[0..-2])
                rangeMax = rangeMax + max[i]
            end
        else
            if lastNonZero
                rangeMax = (lastNonZero == 0) ? "" : min[0..(lastNonZero-1)]
            else
                rangeMax = min[0..-2]
            end
        end
        frontMatch = frontMatch || rangeMax.empty?
        while rangeMax.length < min.length
            rangeMax = rangeMax + (frontMatch ? (max[rangeMax.length].to_i - 1).to_s : "9")
            frontMatch = false
        end
        minMax = pruneMinMax(rangeMax.to_i + 1, max)
        [{min: min, max: rangeMax}, getRanges(minMax[:min], minMax[:max])]
    end

    def rangesToRegex(ranges)
        options = []
        ranges.each do |range|
            doneSkipping = false
            regex = ""
            range[:min].each_char.with_index do |digit, i|
                next if digit.eql?(range[:max][i]) && digit.eql?("0") && !doneSkipping
                regex = regex + ( digit.eql?(range[:max][i]) ? digit : ("[" + digit + "-" + range[:max][i] + "]") )
                doneSkipping = true
            end
            options.push(regex)
        end
        "0*" + optionsRegex(options)
    end

end
