# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  login                  :string(40)      not null
#  name                   :string(255)     default("")
#  super_admin            :boolean(1)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  failed_attempts        :integer(4)      default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

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

    it "should not be valid with too long login" do
      user = User.new(@valid_attributes.merge(:login => "x"*41))
      user.should have_at_least(1).error_on(:login)
    end

    it "should not be valid with too short login" do
      user = User.new(@valid_attributes.merge(:login => "xxx"))
      user.should have_at_least(1).error_on(:login)
    end

    it "should not be valid with invalid characters in login" do
      user = User.new(@valid_attributes.merge(:login => "user 1"))
      user.should have_at_least(1).error_on(:login)
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

  describe "OAuth" do
    before(:each) do
      @user = build(:user)
    end
    
    it "should apply omniauth authentication" do
      @user.apply_omniauth({'info' => {
        "name" => "Sample user",
        "email" => "sample@sample.com",
        "nickname" => "sample"
      }})
      @user.name.should eq("Sample user")
    end
    
    it "password should not be required for oauth" do
      @user.apply_omniauth({'info' => {
        "name" => "Sample user",
        "email" => "sample@sample.com",
        "nickname" => "sample"
      }})
      @user.password = @user.password_confirmation = nil
      @user.password_required?.should be_false
    end

    it "password should be required if not presented and no authentications" do
      @user.password = @user.password_confirmation = nil
      @user.password_required?.should be_true
    end
    
    it "password should be required if not presented and no authentications" do
      @user.password = @user.password_confirmation = nil
      @user.user_tokens.build
      @user.password_required?.should be_false
    end
  end
end
