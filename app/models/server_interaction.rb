require 'json'

# Class name:   ServerInteraction
# Description:  Interaction methods to the DEL FHIR server
class ServerInteraction

    def initialize
        setConnection()
    end

# Method name:  setConnection()
# Description:  Establishes connection with the FHIR server
    def setConnection
        return nil if @client
        @url = "http://hapi.fhir.org/baseR4" # this is the current FHIR Pseudo-DEL location. This URL will update when the FHIR DEL API endpoint is available.
        @client = FHIR::Client.new(@url)
        FHIR::Model.client = @client
        @del_q_profile = "https://impact-fhir.mitre.org/r4/StructureDefinition/del-StandardForm" # specifies the DEL-specific profile name for filtering questionnaires. This URL will update when the FHIR DEL API endpoint is available.
    end

# Method name:  getAllQuestionnaires
# Description:  Retrieves all questionnaire resources matching a given FHIR profile
    def getAllQuestionnaires
        return @questionnaires if @questionnaires
        begin
            setConnection()
            search = { search: { parameters: { _profile: @del_q_profile }, } } # filter for only DEL questionnaire profiles
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

# Method name:  getSummaries(klass)
# Description:  Retrieves key summary information to display for each questionnaire retrieved from the DEL. Current content includes the Questionnaire id, name, version, status, and title.
    def getSummaries(klass)
        summaries = []
        begin
            setConnection()
            params = { resource: klass, summary: "true", search: { parameters: { _profile: @del_q_profile } } }
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
                    res = ent["resource"]
                    unless res["id"] && res["name"] && res["version"] && res["status"] && res["title"] &&
                                res["publisher"] && res["identifier"] && res["identifier"][0] #&& res["code"] 
                        next
                    end
                    {id: res["id"],
                    name: res["name"].gsub("MDS3_0", "MDS3.0").gsub("_", " ") + " (v." + res["version"] + ")",
                    status: res["status"],
                    title: res["title"],
                    publisher: res["publisher"],
                    code: res["code"],
                    assessment: res["identifier"][0]["value"]}
                end
                summaries.push(entry.compact)
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

# Method name:  search(klass, input, assessment)
# Description:  handles FHIR::Measure and FHIR::Questionnaire text searches

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
            search[:search][:parameters][:_count] = 50
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