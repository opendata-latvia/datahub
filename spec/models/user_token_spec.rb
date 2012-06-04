# == Schema Information
#
# Table name: user_tokens
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe UserToken do

  describe "validations" do
    it "should be valid with valid attributes" do
      build(:user_token).should be_valid
    end

    it "should not be valid without provider" do
      user_token = build(:user_token, :provider => "")
      user_token.should_not be_valid
      user_token.should have_at_least(1).error_on(:provider)
    end

    it "should not be valid without uid" do
      user_token = build(:user_token, :uid => "")
      user_token.should_not be_valid
      user_token.should have_at_least(1).error_on(:uid)
    end
  end

  describe "#provider_name" do
    it "returns titleized provider name" do
      user_token = build(:user_token, :provider => "foo bar")
      user_token.provider_name.should eq("Foo Bar")
    end
  end

  describe ".provider_name" do
    context "when provider name is draugiem" do
      it "returns titleized version of it" do
        UserToken.provider_name("draugiem").should eq("Draugiem.lv")
      end
    end

    context "when provider name is google_oauth2" do
      it "returns titleized version of it" do
        UserToken.provider_name("google_oauth2").should eq("Google")
      end
    end

    context "when provider name is something else" do
      it "returns titleized version of it" do
        UserToken.provider_name("foo_bar").should eq("Foo Bar")
      end
    end
  end

end
