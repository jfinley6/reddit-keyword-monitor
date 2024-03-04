class ApplicationController < ActionController::Base
    before_action :set_date

    def set_date
    @date = Time.now.strftime("%m/%d/%Y")
    end
end
