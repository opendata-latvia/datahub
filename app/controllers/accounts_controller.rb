class AccountsController < ApplicationController

  def show
    @account = Account.find_by_login(params[:login]) || not_found
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
