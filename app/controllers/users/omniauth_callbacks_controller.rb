class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :verify_authenticity_token, :except => [:create]

  def destroy
    token = current_user.user_tokens.find(params[:id])
    token.destroy
    flash[:notice] = I18n.t "devise.omniauth_callbacks.destroyed", :kind => UserToken.provider_name(token.provider)
    redirect_to edit_user_registration_path
  end

  def action_missing(provider)
    raise "Service not supported" unless User.omniauth_providers.index(provider.to_sym)

    omniauth = request.env["omniauth.auth"]
    if current_user
      current_user.user_tokens.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => UserToken.provider_name(omniauth['provider'])
      redirect_to edit_user_registration_path
    else
      if user_token = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => UserToken.provider_name(omniauth['provider'])
        sign_in(:user, user_token.user)
        redirect_to account_profile_path(user_token.user.login)
      else
        user = User.new
        user.apply_omniauth(omniauth)
        if user.save
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => UserToken.provider_name(omniauth['provider'] )
          sign_in(:user, user)
          redirect_to account_profile_path(user.login)
        else
          session[:omniauth] = omniauth.except('extra')
          redirect_to new_user_registration_path
        end
      end
    end
  end

  def handle_unverified_request
      true
  end
end
