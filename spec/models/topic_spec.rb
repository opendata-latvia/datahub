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
  describe "validations" do
    it "should be valid with valid attributes" do
      build(:topic).should be_valid
    end

    it "requires slug to be present" do
      topic = build(:topic, :slug => "")
      topic.should_not be_valid
      topic.should have_at_least(1).error_on(:slug)
    end
    
    it "requires description to be present" do
      topic = build(:topic, :description => "")
      topic.should_not be_valid
      topic.should have_at_least(1).error_on(:description)
    end

    it "requires user_id to be present" do
      topic = build(:topic, :user_id => "")
      topic.should_not be_valid
      topic.should have_at_least(1).error_on(:user_id)
    end
    
    it "requires title to be present" do
      topic = build(:topic, :title => "")
      topic.should_not be_valid
      topic.should have_at_least(1).error_on(:title)
    end
    
    it "requires title to be uniq" do
      create(:topic, :title => "test", :slug => "test", :forum_id => 777)
      topic = build(:topic, :title => "test", :slug => "test", :forum_id => 777)
      topic.should_not be_valid
      topic.should have_at_least(1).error_on(:title)
    end
  end

  describe "default scope" do
    it "returns records sorted by updated_at in desc order" do
      topic_1 = create(:topic)
      topic_2 = create(:topic, :updated_at => Time.zone.now + 10.minutes)
    
      Topic.all.should eq([topic_2, topic_1])
    end
  end

  describe ".recent" do
    before do
      (1..5).each do |i|
        instance_variable_set("@topic_#{i}", create(:topic, :updated_at => Time.zone.now + i.minutes))
      end
    end

    context "when passed in count arg" do
      it "returns n records based on arg" do
        Topic.recent(3).should eq([@topic_5, @topic_4, @topic_3])
      end
    end
    
    context "when no arg specified" do
      it "returns 5 records by default" do
        Topic.recent.should eq([@topic_5, @topic_4, @topic_3, @topic_2, @topic_1])
      end
    end
  end
end
