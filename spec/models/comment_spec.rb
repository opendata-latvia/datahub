# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  commentable_type :string(255)
#  commentable_id   :integer(4)
#  user_id          :integer(4)
#  content          :text
#  ancestry         :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe Comment do
  
  before(:each) do
    @comment = build(:comment)
  end
  
  it "should be valid" do
    @comment.should be_valid
  end
  
end
