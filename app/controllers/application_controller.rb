class ApplicationController < ActionController::Base
  include ProjectPathHelper

  protect_from_forgery
  
  protected
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def must_be_super_admin
    authorize!(:manage, "Administration")
  end
  
end
