module Cms
  module Sites

    # Handles Sign In/Out for public site.
    class SessionsController < Devise::SessionsController
      include Cms::ContentPage
      helper AuthenticationHelper
      helper UiElementsHelper

      rescue_from ActionController::UnknownFormat, with: :raise_not_found

      template :default

      def new
        use_page_title 'Login'
        super
      end

      protected

        def raise_not_found
          Rails.logger.error 'Unknown format exception caught!'
          redirect_to '/'
        end  

    end
  end
end
