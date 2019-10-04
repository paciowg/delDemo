class SessionStack

    @sessionHash = Hash.new

    def self.create(id, loinc = false)
        prune()
        @sessionHash[id] = {q: [{"started" => Time.now, "loinc" => loinc}], qr: nil}
    end

    def self.loinc?(id)
        @sessionHash[id][:q][0]["loinc"]
    end

    def self.qRead(id)
        @sessionHash[id][:q]
    end

    def self.qLength(id)
        @sessionHash[id][:q].length - 1
    end

    def self.qrRead(id)
        @sessionHash[id][:qr]
    end

    def self.push(id, input)
        current = (input["page"] ? input["page"].to_i - 1 : (input["back"] ? input["back"].to_i + 1 : 1) )
        input["current"] = current
        index = @sessionHash[id][:q].index{ |page| page["current"] == current }
        @sessionHash[id][:q].delete_at(index) if index
        @sessionHash[id][:q].push(input) unless input["edit_post_preview"].eql?("true")
    end

    def self.qrPush(id, qr)
        @sessionHash[id][:qr] = qr
    end

    def self.delete(id)
        @sessionHash.delete(id)
    end

    def self.prune() #removes sessions older than 5 hours
        @sessionHash.delete_if { |id, session| (Time.now - session[:q][0]["started"]) > (5 * 60 * 60) }
    end

end