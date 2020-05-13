class EhrConnectionTracker

    @ehrconnections = Hash.new

    def self.establish(ehrSessionID)
        @ehrconnections[ehrSessionID] = { si: EhrServerInteraction.new, lastUsed: Time.now }
        prune
    end

    def self.get(ehrSessionID)
        establish(ehrSessionID) if @ehrconnections[ehrSessionID].blank?
        @ehrconnections[ehrSessionID][:lastUsed] = Time.now
        prune
        @ehrconnections[ehrSessionID][:si]
    end

    def self.prune #removes connections older than 1.5 hours
        safeHours = 1.5
        @ehrconnections.delete_if { |ehrSessionID, connection| (Time.now - ehrconnection[:lastUsed]) > (safeHours * 60 * 60) }
    end

end