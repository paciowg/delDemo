class EhrSendController < ApplicationController
    def index

        @pageLocation = ["Patient", "EhrSend"]
        # convert the questionnareResponse to SDC
 #       convert_qr_to_sdc

        # enter FHIRClient POST send to the EHR.

        @ehrUrl = "https://api.logicahealth.org/mCODEv1/open" # changed to mCODE temp FHIR server for testing purposes.
#        @ehrUrl = "https://hospital-pseudo-ehr.herokuapp.com/api/v1/questionnaire_responses" # pseudo-EHR

        # initialize the FHIR model
        client = FHIR::Client.new(@ehrUrl)
        FHIR::Model.client = client
        
        # Example: send a Patient resource to a Target FHIR server
        sdcFile = "#{Rails.root}/public/datafiles/sdcBSJ1.json"
        json = File.read(sdcFile)
        sdc_qr = FHIR.from_contents(json) # read the json file and populate a QuestionnaireResponse object.
        puts "creating new SDC QuestionnaireResponse..."
        my_sdc_qr = client.create(sdc_qr) # CREATE the QuestionnaireResponse resource to the target FHIR server.
    end

    # method: convert_qr_to_sdc
    # description: converts the saved QuestionnaireResponse output to an SDC resource. At minimum, this requires the addition of the Patient resource and specifying the SDC QuestionnaireResponse profile.
    def convert_qr_to_sdc
        # stub
        @pas_assessment = Submission.submitAssessment(SessionStack.qrRead(session.id))
        puts "pas_assessment:\n#{@pas_assessment}"
    end
end
