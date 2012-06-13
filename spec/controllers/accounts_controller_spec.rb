require 'spec_helper'

describe AccountsController do
  before do
    @account = create(:account) 
  end

  it "should show account" do
    get :show, :login => @account.login
    assigns(:account).login.should eq(@account.login)
    response.should be_success
  end
end
