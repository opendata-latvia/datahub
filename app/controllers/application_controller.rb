class ApplicationController < ActionController::Base
  include ProjectPathHelper

  protect_from_forgery
  
  protected
  
  rescue_from CanCan::AccessDenied do |exception|
    logger.error "[cancan] Access denied, message: #{exception.message}"
    redirect_to root_url, :alert => exception.message
  end
  
  def must_be_super_admin
    authorize!(:manage, "Administration")
  end
  
end
