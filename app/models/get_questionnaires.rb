OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE #TODO, fix hackish ssl certification workaround
require 'json'
require 'csv'

class GetQuestionnaires

    def self.getOldQuestionnaire
        questionnaires = CSV.read("storage/Data_Elements.csv")
        keys = questionnaires[0]
        questionnaires = questionnaires.drop(1)
        return questionnaires.map{ |values| Hash[keys.zip(values)] }
    end

    def self.getAllQuestionnaires
        @url = "https://impact-fhir.mitre.org/r4/"
        @client = FHIR::Client.new(@url)
        FHIR::Model.client = @client
        allQuestionnaires = @client.read_feed(FHIR::Questionnaire) # fetch Bundle of Questionnaires
        json = allQuestionnaires.response.values[2]
        @questionnaireHash = JSON.parse(json)
    end

    def self.getQuestionnaire(version)
        if @questionnaireHash.nil?
            getAllQuestionnaires()
        end
        @questionnaireHash["entry"].each do |questionnaire|
            if questionnaire["resource"]["id"].eql?(version)
                return questionnaire
            end
        end 
        return nil
    end
end