class EhrSendController < ApplicationController
    def index

        @pageLocation = ["Patient", "Preview", "Submission", "EhrSend"]
        # convert the questionnareResponse to SDC
 #       convert_qr_to_sdc

        # enter FHIRClient POST send to the EHR.

      # @ehrUrl = "https://api.logicahealth.org/mCODEv1/open"
@ehrUrl = "http://hospital-pseudo-ehr.herokuapp.com/api/v1/questionnaire_responses" # pseudo-EHR

        # MLT: test to pull the info off of the stack.
#        @mypt = SessionStack.ptRead(session.id)
#        puts "\nmypt value:\n #{@mypt.inspect}"  # MLT: test of passing patient stack variable. This assumes the patient ID was retrieved prior to the completion of the assessment.

        # initialize the FHIR model
        client = FHIR::Client.new(@ehrUrl)
        FHIR::Model.client = client
        
#        @assessment = qrRead(session.id)
#        puts "Assessment QR JSON: #{@assessment.to_json}"

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
