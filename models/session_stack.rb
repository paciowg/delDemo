class SessionStack

    @sessionHash = Hash.new

    def self.create(id, loinc = false)
        if @sessionHash[id] # sets all prior references to nil and runs GC (seems to solve memory leak)
            @sessionHash[id][:q].delete_if{ |e| true }
            @sessionHash[id][:q] = nil
            @sessionHash[id][:q] = [{"started" => Time.now, "loinc" => loinc}]
            @sessionHash[id][:qr] = nil
            @sessionHash[id][:sr][0] = nil
            @sessionHash[id][:sr][1] = nil
            @sessionHash[id][:sr] = nil
            @sessionHash[id][:sr] = [nil, nil]
            @sessionHash[id][:pt] = nil  # MLT: added patient to SessionStack
            @sessionHash[id][:ehr] = nil  # MLT: added patient to SessionStack
        else 
            @sessionHash[id] = {q: [{"started" => Time.now, "loinc" => loinc}], qr: nil, sr: [nil, nil]}
            @sessionHash[id][:qSummaries] = { active: nil, inactive: nil }
        end
        prune
        GC.start
    end

    def self.prune() #removes sessions older than 1.5 hours
        safeHours = 1.5
        @sessionHash.delete_if { |id, session| (Time.now - session[:q][0]["started"]) > (safeHours * 60 * 60) }
    end

    def self.loinc?(id)
        @sessionHash[id][:q][0]["loinc"]
    end

    def self.qrRead(id)
        @sessionHash[id][:qr]
    end

    def self.qrPush(id, qr)
        @sessionHash[id][:qr] = qr
    end

    def self.ptRead(id)
        @sessionHash[id][:pt]
    end

    def self.ptPush(id, pt)
        @sessionHash[id][:pt] = pt
    end

    def self.ehrRead(id)
        @sessionHash[id][:ehr]
    end

    def self.ehrPush(id, ehr)
        @sessionHash[id][:ehr] = ehr
    end

    def self.searchPush(id, searchResults)
        @sessionHash[id][:sr] = searchResults
    end

    def self.searchRead(id)
        @sessionHash[id][:sr]
    end

    def self.qRead(id)
        @sessionHash[id][:q]
    end

    def self.qLength(id)
        @sessionHash[id][:q].length - 1
    end

    def self.push(id, input)
        current = input["page"] ? input["page"].to_i - 1 : (input["back"] ? input["back"].to_i + 1 : 1)
        input["current"] = current
        index = @sessionHash[id][:q].index{ |page| page["current"] == current }
        @sessionHash[id][:q].delete_at(index) if index
        @sessionHash[id][:q].push(input) unless input["edit_post_preview"].eql?("true")
    end

    def self.qSummariesPush(id, active, inactive)
        @sessionHash[id][:qSummaries][:active] = active
        @sessionHash[id][:qSummaries][:inactive] = inactive
    end

    def self.qSummariesRead(id)
        create(id) if @sessionHash[id].nil?
        @sessionHash[id][:qSummaries]
    end

end