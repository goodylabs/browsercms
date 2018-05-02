module Cms
  class ApplicationController < ::ApplicationController
    include Cms::AdminController

    rescue_from ActionController::UnknownFormat, with: :raise_not_found
    
    before_action :no_browser_caching
    
    def no_browser_caching
      expires_now
    end
  end
end