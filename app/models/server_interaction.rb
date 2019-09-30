require 'json'

class ServerInteraction

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

    def self.getAllLibraries
        return @libraries if @libraries
        begin
            setConnection()
            @libraries = getAllResources(FHIR::Library)
        rescue
            @libraries = nil
        end
        @libraries
    end

    def self.getAllResources(klasses = nil, search = nil)
        replies = getAllReplies(klasses, search)
        return nil unless replies
        resources = []
        replies.each do |reply|
            resources.push(reply.resource.entry.collect{ |singleEntry| singleEntry.resource })
        end
        resources.compact!
        resources.flatten(1)
    end

    def self.getAllReplies(klasses = nil, search = nil)
        klasses = coerce_to_a(klasses)
        replies = []
        if klasses.present?
            klasses.each do |klass|
                replies.push(search.present? ? @client.search(klass, search) : @client.read_feed(klass))
                while replies.last
                    replies.push(@client.next_page(replies.last))
                end
            end
        else
            replies.push(@client.all_history)
        end
        replies.compact!
        replies.blank? ? nil : replies
    end

    def self.getSummaries(klass)
        summaries = []
        begin
            setConnection()
            replies = [].push(JSON.parse(@client.raw_read(resource: klass, summary: "true").response[:body]))
            while replies.last
                nextLink = replies.last["link"].select{ |link| link["relation"].eql?("next") }
                break if nextLink.blank?
                url = nextLink[0]["url"] + "&_summary=true"
                replies.push(JSON.parse(@client.raw_read_url(url).response[:body]))
            end
            replies.compact!
            summaries = []
            replies.each do |reply|
                entry = reply["entry"].collect do |ent| 
                    {id: ent["resource"]["id"],
                    name: ent["resource"]["name"] + " (v." + ent["resource"]["version"] + ")",
                    status: ent["resource"]["status"],
                    title: ent["resource"]["title"],
                    publisher: ent["resource"]["publisher"],
                    code: ent["resource"]["code"]}
                end
                summaries.push(entry)
            end
            summaries.compact!
            summaries.flatten!(1)
        rescue
            summaries = []
        end
        summaries
    end

    def self.getQuestionnaire(id)
        begin
            setConnection()
            return @client.search_existing(FHIR::Questionnaire, id).resource
        rescue
            return nil
        end
    end

    def self.searchMeasures(input = nil)
        measureProfile = "https://impact-fhir.mitre.org/r4/StructureDefinition/del-StandardFormQuestion"
        begin
            setConnection()
            search = { search: { parameters: { _count: 50, _profile: measureProfile } } }
            search[:search][:parameters]["title:contains"] = input if input.present?
            return getAllResources(FHIR::Measure, search)
        rescue
            return nil
        end
    end

    def self.coerce_to_a(param)
        return nil unless param
        param.respond_to?('to_a') ? param.to_a : Array.[](param)
    end

end