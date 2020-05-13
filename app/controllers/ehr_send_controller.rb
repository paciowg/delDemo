class EhrSendController < ApplicationController
    def index
        # enter FHIRClient POST send to the EHR.

        @ehrUrl = "https://api.logicahealth.org/mCODEv1/open" # changed to mCODE temp FHIR server for testing purposes.

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
end
