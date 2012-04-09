class ApplicationController < ActionController::Base
  include ProjectPathHelper

  protect_from_forgery
end
