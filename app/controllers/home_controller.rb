class HomeController < ApplicationController

  def index
    if user_signed_in?
      redirect_to account_profile_path(current_user.login)
    end
  end

end