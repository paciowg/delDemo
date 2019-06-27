OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE #TODO, fix hackish ssl certification workaround

class GetQuestionnaires

    def self.setConnection
        @url = "https://impact-fhir.mitre.org/r4/"    
        @client = FHIR::Client.new(@url)
        FHIR::Model.client = @client
    end

    def self.getAllQuestionnaires
        return @questionnaires if @questionnaires
        begin
            setConnection()
            @questionnaires = getAllResources(FHIR::Questionnaire)
            @questionnaires.select!{ |q| !q.name.eql?("TimTest")} # Ask Tim to remove TimTest
        rescue
            @questionnaires = nil
        end
        @questionnaires
    end

    def self.getAllResources(klasses = nil)
        replies = getAllReplies(klasses)
        return nil unless replies
        resources = []
        replies.each do |reply|
            resources.push(reply.resource.entry.collect{ |singleEntry| singleEntry.resource })
        end
        resources.compact!
        resources.flatten(1)
    end

    def self.getAllReplies(klasses = nil)
        klasses = coerce_to_a(klasses)
        replies = []
        if !blank?(klasses)
            klasses.each do |klass|
                replies.push(@client.read_feed(klass))
                while !replies.last.nil?
                    replies.push(@client.next_page(replies.last))
                end
            end
        else
            replies.push(@client.all_history)
        end
        replies.compact!
        blank?(replies) ? nil : replies
    end

    def self.blank?(param)
        param.nil? || param.empty?
    end

    def self.coerce_to_a(param)
        return nil unless param
        param.respond_to?('to_a') ? param.to_a : Array.[](param)
    end

    def self.getQuestionnaire(version)
        @questionnaires = getAllQuestionnaires unless @questionnaires
        @questionnaires.find{ |q| q.id.eql?(version) }
    end

end