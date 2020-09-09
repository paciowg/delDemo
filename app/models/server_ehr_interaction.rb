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

#    private

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