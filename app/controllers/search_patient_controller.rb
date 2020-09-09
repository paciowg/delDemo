class SearchPatientController < ApplicationController

###########################
# description: display search results
###########################
    def index
        # MLT: test to pull the info off of the stack.
        unless SessionStack.ptRead(session.id).nil?
            @mypt = SessionStack.ptRead(session.id)
            puts "\nmypt value:\n #{@mypt.inspect}"  # MLT: test of passing patient stack variable.
        end
    end

end
