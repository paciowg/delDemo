class AboutController < ApplicationController
    def index
        SessionStack.delete(session.id)
    end
end
