require 'json'

# Class name:   EhrServerInteraction
# Description:  Interaction methods to the EHR FHIR server
class EhrServerInteraction

    def ehr_initialize
        ehrSetConnection()
    end

# Method name:  ehrSetConnection()
# Description:  Establishes connection with the EHR FHIR server
    def ehrSetConnection
        return nil if @clientPatient
        @url = "http://data-mgr.azurewebsites.net/open" # this is a temporary FHIR endpoint containing patient resources. This URL will update when the FHIR EHR endpoint is available.
        @clientPatient = FHIR::Client.new(@url)
        FHIR::Model.client = @clientPatient
    end

# Method name:  getAllPatients
# Description:  Retrieves all patient resources matching a given FHIR profile
    def getAllPatients
        return @patients if @patients
        begin
            ehrSetConnection()
            search = { search: { parameters: { _count: 50 }, } } # display 50 entries at a time
            @patients = getPatientAllResources(FHIR::Patients, search)
        rescue
            @patients = nil
        end
        @patients
    end

    def getPatientAllResources(klasses = nil, search = nil)
        replies = getPatientAllReplies(klasses, search)
        return nil unless replies
        resources = []
        replies.each do |reply|
            resources.push(reply.resource.entry.collect{ |singleEntry| singleEntry.resource })
        end
        resources.compact!
        resources.flatten(1)
    end

    def getPatientAllReplies(klasses = nil, search = nil)
        klasses = coerce_to_a(klasses)
        replies = []
        if klasses.present?
            klasses.each do |klass|
                replies.push(search.present? ? @clientPatient.search(klass, search) : @clientPatient.read_feed(klass))
                while replies.last
                    replies.push(@clientPatient.next_page(replies.last))
                end
            end
        else
            replies.push(@clientPatient.all_history)
        end
        replies.compact!
        replies.blank? ? nil : replies
    end

# Method name:  getPatientSpecificResource
# Description:  Retrieves a specific Patient resource
    def getPatientSpecificResource(klass, id)
        begin
            ehrSetConnection()
            return @clientPatient.search_existing(klass, id).resource
        rescue
            return nil
        end
    end

# Method name:  patientSearch(klass, input, patient)
# Description:  handles FHIR::Patient text searches

    def patientSearch(klass, inputPatientID = nil, patient = nil) 
        begin
            ehrSetConnection()
            return [getPatientSpecificResource(klass, patient, patientSearchParams(klass))] 
        rescue
            return nil
        end
    end

    private

    # search parameters for FHIR::Patient text searches
    def patientSearchParams(klass, inputPatientID = nil)
        search = { search: { parameters: Hash.new } }

        if klass.eql?(FHIR::Patient)
            search[:search][:parameters][:_id] = input if inputPatientID.present
            @patientId = "id"
            @patientBirthDate = "birthDate"
            @patientName = "name"
            end
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