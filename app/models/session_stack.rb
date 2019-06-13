class SessionStack

    @@sessionHash = Hash.new

    def self.create(id)
        @@sessionHash[id] = []
    end

    def self.read(id)
        @@sessionHash[id]
    end

    def self.push(id, input)
        @@sessionHash[id].each do |section|
            if section.keys.include?(input.keys[1]) #banks on there being an initial "version" key-value pair
                @@sessionHash[id].delete(section)
            end
        end
        @@sessionHash[id].push(input)
    end

    def self.pop(id)
        @@sessionHash[id].pop()
    end

    def self.delete(id)
        @@sessionHash.delete(id)
    end

    def self.delete_all()
        @@sessionHash.clear()
    end

end