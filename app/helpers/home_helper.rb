module HomeHelper
    def populateQuestionnaire
        @questionnaire = FHIR::Questionnaire.create(
            title: "DEL Demo Questionnaire",
            publisher: "The MITRE Corporation",
            experimental: true)
    end
end
