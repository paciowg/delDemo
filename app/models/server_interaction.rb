require 'json'

class ServerInteraction

    def initialize
        setConnection()
    end

    def setConnection
        # @url = "https://api.logicahealth.org/PACIO/open"
        return nil if @client
        @url = "https://impact-fhir.mitre.org/r4"
        @client = FHIR::Client.new(@url)
        FHIR::Model.client = @client
    end

    def getAllQuestionnaires
        return @questionnaires if @questionnaires
        begin
            setConnection()
            search = { search: { parameters: { _count: 50 } } }
            @questionnaires = getAllResources(FHIR::Questionnaire, search)
        rescue
            @questionnaires = nil
        end
        @questionnaires
    end

    def getAllResources(klasses = nil, search = nil)
        replies = getAllReplies(klasses, search)
        return nil unless replies
        resources = []
        replies.each do |reply|
            resources.push(reply.resource.entry.collect{ |singleEntry| singleEntry.resource })
        end
        resources.compact!
        resources.flatten(1)
    end

    def getAllReplies(klasses = nil, search = nil)
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

    def getSummaries(klass)
        summaries = []
        begin
            setConnection()
            params = { resource: klass, summary: "true", search: { parameters: { _count: 50 } } }
            replies = [].push(JSON.parse(@client.raw_read(params).response[:body]))
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
                    name: ent["resource"]["name"].sub("MDS3_0", "MDS3.0") + " (v." + ent["resource"]["version"] + ")",
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

    def getSpecificResource(klass, id, search = {})
        begin
            setConnection()
            return @client.search_existing(klass, id, search).resource
        rescue
            return nil
        end
    end

    # handles FHIR::Measure and FHIR::Questionnaire text searches
    def search(klass, input = nil, assessment = nil)
        begin
            setConnection()
            return getAllResources(klass, itemSearchParams(klass, input)) if assessment.blank?
            return [getSpecificResource(klass, assessment, itemSearchParams(klass))]
        rescue
            return nil
        end
    end

    private

    # search parameters for FHIR::Measure and FHIR::Questionnaire text searches
    def itemSearchParams(klass, input = nil)
        search = { search: { parameters: Hash.new } }
        profiles = Hash.new
        profiles[:m] = "https://impact-fhir.mitre.org/r4/StructureDefinition/del-StandardFormQuestion"
        profiles[:q] = "https://impact-fhir.mitre.org/r4/StructureDefinition/del-StandardForm"
        if klass.eql?(FHIR::Measure)
            search[:search][:parameters][:_profile] = profile[:m]
            search[:search][:parameters][:_count] = 50
            search[:search][:parameters]["title:contains"] = input if input.present?
        elsif klass.eql?(FHIR::Questionnaire)
            search[:search][:parameters][:_profile] = profiles[:q]
            search[:search][:parameters][:_count] = 25
            search[:search][:parameters]["item-text:contains"] = input if input.present?
            elements = "id,name,version"
            itemDepth = 5
            for i in 1..itemDepth
                itemStr = ("item." * i)
                elements += "," + itemStr + "text," + itemStr + "prefix," + itemStr + "linkId"
            end
            search[:search][:parameters]["_elements"] = elements
        else
            return nil
        end
        search
    end

    def coerce_to_a(param)
        return nil unless param
        param.respond_to?('to_a') ? param.to_a : Array.[](param)
    end

end