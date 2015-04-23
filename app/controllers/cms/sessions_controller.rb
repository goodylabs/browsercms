module Cms
  # Handles the login/logout function of the site.
  class SessionsController < Devise::SessionsController
    include Cms::AdminController
    before_filter :redirect_to_cms_site, :only => [:new]

    layout 'cms/application'

    def create
      cookies[:admin_logged_in] = "true"
      super
    end

    def destroy
      cookies[:admin_logged_in] = ""
      super
    end

    def new
      use_page_title 'Login'
      super
    end

  end
end