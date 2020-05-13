#########################
#   Patient Controller
#   Description: Connects to EHR Server and retrieves the Patient resource for a given FHIR ID.
#########################

class PatientController < ApplicationController
    def index
        @pageLocation = ["Patient"]

        # Connect to FHIR open endpoint. Change @url to FHIR pseudo-EHR endpoint when available.
#        @ehrUrl = "http://data-mgr.azurewebsites.net/open"
        @ehrUrl = "https://api.logicahealth.org/mCODEv1/open" # changed to mCODE temp FHIR server for testing purposes.

        # initialize the FHIR model
        client = FHIR::Client.new(@ehrUrl)
        FHIR::Model.client = client

        # retrieve the patient with an id 'patientBSJ1': Betsy Smith-Johnsohn
        @patientInstance = FHIR::Patient.read(params[:inputPatientID])

        # ###### DEBUG console output: display the patient record
        puts "Target EHR URL: #{@ehrUrl}"
        puts "patient datatype: #{@patientInstance.class} \n"
        puts "patient ID: #{@patientInstance.id} \n"

        # let's assign the name to an instance variable to simplify the path structure.
        @patientName = @patientInstance.name
        puts "\tfirst name: #{@patientName[0].given[0]} \n"
        puts "\tlast name: #{@patientName[0].family} \n"
        puts "\tbirth date: #{@patientInstance.birthDate} \n"
        puts "\tgender: #{@patientInstance.gender} \n"

        # ###### End of DEBUG

        # store the patient instance data in a session to show if user returns to the homepage
        session[:patientInstance] = @patientInstance

# The following code is commented out. Can't get it to work at this time. The above works in the short-term.

=begin
        ehrServerInteraction = EhrConnectionTracker.get(ehrSessionID.id)

        @inputPatientID = params[:inputPatientId]
        @patientId = params[:patient]

        @patientInstance = ehrServerInteraction.getPatientSpecificResource(FHIR::Patient, @inputPatientID)
        @patientName = @patientInstance.name
        puts @patientName
=end
    end
end
