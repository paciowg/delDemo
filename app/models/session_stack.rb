class SessionStack

    @@sessionHash = Hash.new

    def self.create(id)
        @@sessionHash[id] = []
    end

    def self.read(id)
        @@sessionHash[id]
    end

    def self.push(id, input)
        @@sessionHash[id].push(input)
    end

    def self.pop(id)
        @@sessionHash[id].pop()
    end

    def self.delete(id)
        @@sessionHash.delete(id)
    end

end