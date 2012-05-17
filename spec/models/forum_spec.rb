# == Schema Information
#
# Table name: forums
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  slug        :string(255)     not null
#  description :text            default(""), not null
#  position    :integer(4)      not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Forum do
  before(:each) do
    @forum = build(:forum)
  end
  
  it "should be valid" do
    @forum.should be_valid
  end
  
end
