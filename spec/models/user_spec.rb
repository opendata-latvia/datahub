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
      user = User.new(@valid_attributes.except(:login))
      user.should have_at_least(1).error_on(:login)
    end

  end

end
