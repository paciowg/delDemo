class EhrController < ApplicationController
###########################
# description: display search results
###########################
def index

    # store the patient instance data in a session to show if user returns to the homepage
    SessionStack.ehrPush(session.id, (params[:inputEhrID]))
    # MLT: test to pull the info off of the stack.

    unless SessionStack.ehrRead(session.id).nil?
        @ehr = SessionStack.ehrRead(session.id)
        puts "\nehr value:\n #{@ehr.inspect}"  # MLT: test of passing patient stack variable.
    end
end
end
