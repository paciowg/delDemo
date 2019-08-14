class SessionStack

    @@sessionHash = Hash.new

    def self.create(id)
        prune()
        @@sessionHash[id] = {q: [{"started" => Time.now}], qr: nil}
    end

    def self.qRead(id)
        @@sessionHash[id][:q]
    end

    def self.qrRead(id)
        @@sessionHash[id][:qr]
    end

    def self.push(id, input)
        @@sessionHash[id][:q].each do |section|
            unless (section.keys & input.keys.select{ |key| !key.eql?("version") }).empty?
                @@sessionHash[id][:q].delete(section)
            end
        end
        @@sessionHash[id][:q].push(input) unless input.keys.select{ |key| !key.eql?("version") }.empty?
        puts "\n\n-----\nThe session currently has " + @@sessionHash[id][:q].length.to_s + " pages tracked\n-----\n\n"
    end

    def self.qrPush(id, qr)
        @@sessionHash[id][:qr] = qr
    end

    def self.delete(id)
        @@sessionHash.delete(id)
    end

    def self.prune() #removes sessions older than 3 hours
        @@sessionHash.delete_if { |id, session| (Time.now - session[:q][0]["started"]) > (3 * 60 * 60) }
    end

end