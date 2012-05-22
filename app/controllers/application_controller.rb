class ApplicationController < ActionController::Base
  include ProjectPathHelper
  before_filter :set_locale

  protect_from_forgery

  protected

  rescue_from CanCan::AccessDenied do |exception|
    logger.error "[cancan] Access denied, message: #{exception.message}"
    redirect_to root_url, :alert => exception.message
  end

  private

  VALID_LOCALES = %w(lv en)

  def set_locale
    if VALID_LOCALES.include? params[:locale]
      session[:locale] = params[:locale].to_sym
    end
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
