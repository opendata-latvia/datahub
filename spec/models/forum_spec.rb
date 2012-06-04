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

  describe "validations" do 
    it "should be valid with valid attributes" do
      build(:forum).should be_valid
    end

    it "should not be valid without slug" do
      forum = build(:forum, :slug => "")
      forum.should_not be_valid
      forum.should have_at_least(1).error_on(:slug)
    end

    it "should not be valid without position" do
      forum = build(:forum, :position => "")
      forum.should_not be_valid
      forum.should have_at_least(1).error_on(:position)
    end

    it "should not be valid without title" do
      forum = build(:forum, :title => "")
      forum.should_not be_valid
      forum.should have_at_least(1).error_on(:title)
    end

    it "should not be valid with duplicate title" do
      create(:forum, :title => "test", :slug => "test")
      forum = build(:forum, :title => "test", :slug => "test")
      forum.should_not be_valid
      forum.should have_at_least(1).error_on(:title)
    end

    it "should not be valid if position is not integer" do
      build(:forum, :position => "test").should_not be_valid
      build(:forum, :position => 0.1).should_not be_valid
    end
  end

  describe "default scope" do
    it "returns records ordered by position" do
      forum_1 = create(:forum, :position => 2)
      forum_2 = create(:forum, :position => 1)
      Forum.all.should eq([forum_2, forum_1])
    end
  end

end
