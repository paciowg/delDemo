class ConnectionTracker

    @connections = Hash.new

    def self.establish(sessionID)
        @connections[sessionID] = { si: ServerInteraction.new, lastUsed: Time.now }
        prune()
    end

    def self.get(sessionID)
        establish(sessionID) if @connections[sessionID].blank?
        @connections[sessionID][:lastUsed] = Time.now
        prune()
        @connections[sessionID][:si]
    end

    def self.prune #removes connections older than 5 hours
        @connections.delete_if { |sessionID, connection| (Time.now - connection[:lastUsed]) > (5 * 60 * 60) }
    end

end