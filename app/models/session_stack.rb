class SessionStack

    @@sessionHash = Hash.new

    def self.create(id)
        @@sessionHash[id] = [{"started" => Time.now}]
        prune()
    end

    def self.read(id)
        @@sessionHash[id]
    end

    def self.push(id, input)
        @@sessionHash[id].each do |section|
            if section.keys.include?(input.keys[1]) #banks on input having an initial "version" key-value pair
                @@sessionHash[id].delete(section)
            end
        end
        @@sessionHash[id].push(input)
    end

    def self.delete(id)
        @@sessionHash.delete(id)
    end

    def self.prune() #removes sessions older than 3 hours
        @@sessionHash.delete_if { |id, session| (Time.now - session[0]["started"]) > (3 * 60 * 60) }
    end

end