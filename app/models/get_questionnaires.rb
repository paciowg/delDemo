require 'json'

class GetQuestionnaires

    def self.setConnection
        # @url = "https://api.logicahealth.org/PACIO/open"
        @url = "https://impact-fhir.mitre.org/r4"
        @client = FHIR::Client.new(@url)
        FHIR::Model.client = @client
    end

    def self.getAllQuestionnaires
        return @questionnaires if @questionnaires
        begin
            setConnection()
            @questionnaires = getAllResources(FHIR::Questionnaire)
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
        unless blank?(klasses)
            klasses.each do |klass|
                replies.push(@client.read_feed(klass))
                while replies.last
                    replies.push(@client.next_page(replies.last))
                end
            end
        else
            replies.push(@client.all_history)
        end
        replies.compact!
        blank?(replies) ? nil : replies
    end

    def self.getQuestionnaireVersions()
        begin
            setConnection()
            replies = [].push(JSON.parse(@client.raw_read(resource: FHIR::Questionnaire, summary: "true").response[:body]))
            while replies.last
                nextLink = replies.last["link"].select{ |link| link["relation"].eql?("next") }
                break if blank?(nextLink)
                url = nextLink[0]["url"] + "&_summary=true"
                replies.push(JSON.parse(@client.raw_read_url(url).response[:body]))
            end
            replies.compact!
            @questionnaireVersions = []
            replies.each do |reply|
                entry = reply["entry"].collect do |ent| 
                    {id: ent["resource"]["id"],
                    name: ent["resource"]["name"] + " (v." + ent["resource"]["version"] + ")",
                    status: ent["resource"]["status"],
                    title: ent["resource"]["title"],
                    publisher: ent["resource"]["publisher"]}
                end
                @questionnaireVersions.push(entry)
            end
            @questionnaireVersions.compact!
            @questionnaireVersions.flatten!(1)
        rescue
            @questionnaireVersions = []
        end
        @questionnaireVersions
    end

    def self.getQuestionnaire(id)
        begin
            setConnection()
            return @client.search_existing(FHIR::Questionnaire, id).resource
        rescue
            return nil
        end
    end

    def self.blank?(param)
        param.nil? || param.empty?
    end

    def self.coerce_to_a(param)
        return nil unless param
        param.respond_to?('to_a') ? param.to_a : Array.[](param)
    end

end