class AccountsController < ApplicationController

  def show
    @account = Account.find_by_login!(params[:login])
  end

end
