require 'spec_helper'

describe User do

  describe "validations" do
    before(:all) do
      @valid_attributes = {
        :login => 'user',
        :email => 'user@example.com',
        :password => 'secret',
        :password_confirmation => 'secret'
      }
    end

    it "should be valid with valid attributes" do
      User.new(@valid_attributes).should be_valid
    end

    it "should not be valid without login" do
      user = User.new(@valid_attributes.except(:login))
      user.should have_at_least(1).error_on(:login)
    end

    it "should not be valid without email" do
      user = User.new(@valid_attributes.except(:email))
      user.should have_at_least(1).error_on(:email)
    end

    it "should not be valid with duplicate login" do
      user = create(:user)
      user2 = User.new(@valid_attributes.merge(:login => user.login))
      user2.should have_at_least(1).error_on(:login)
    end

    it "should not be valid with duplicate email" do
      user = create(:user)
      user2 = User.new(@valid_attributes.merge(:email => user.email))
      user2.should have_at_least(1).error_on(:email)
    end

  end

  describe "account" do
    before(:each) do
      @user = create(:user)
    end

    it "should create user account when user is created" do
      @user.account.should_not be_nil
      @user.account.login.should == @user.login
    end

    it "should update user account when user login and name is updated" do
      @user.update_attributes(:login => 'dummy', :name => 'Dummy Dummy')
      @user.account.login.should == 'dummy'
      @user.account.name.should == 'Dummy Dummy'
    end

    it "should destroy user account when user is destroyed" do
      account = @user.account
      @user.destroy
      Account.find_by_id(account.id).should be_nil
    end
  end

end
