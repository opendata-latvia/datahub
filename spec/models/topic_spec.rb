# == Schema Information
#
# Table name: topics
#
#  id          :integer(4)      not null, primary key
#  forum_id    :integer(4)      not null
#  user_id     :integer(4)      not null
#  title       :string(255)     not null
#  slug        :string(255)     not null
#  description :text            default(""), not null
#  commentable :boolean(1)      default(FALSE)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Topic do
  before(:each) do
    @topic = build(:topic)
  end
  
  it "should be valid" do
    @topic.should be_valid
  end
end
