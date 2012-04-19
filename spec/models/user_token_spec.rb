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
  before(:each) do
    @user_token = FactoryGirl.build :user_token
  end
  
  it "should be valid" do
    @user_token.should be_valid
  end
end
