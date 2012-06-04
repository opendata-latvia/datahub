# == Schema Information
#
# Table name: accounts
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  login      :string(40)      not null
#  name       :string(255)     default("")
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Account do
  before(:each) do
    @user = create(:user)
    @account = @user.build_account
  end

  describe "#email" do
    it "returns user email" do
      @account.email.should eq(@user.email)
    end
  end

  describe "#to_param" do
    it "returns login" do
      @account.to_param.should eq(@account.login)
    end
  end
end
