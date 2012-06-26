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
 
  describe "validations" do
    it "should be valid with valid attributes" do
      build(:comment).should be_valid
    end

    it "should not be valid without commentable_type" do
      comment = build(:comment, :commentable_type => "")
      comment.should_not be_valid
      comment.should have_at_least(1).error_on(:commentable_type)
    end

    it "should not be valid without commentable_id" do
      comment = build(:comment, :commentable_id => "")
      comment.should_not be_valid
      comment.should have_at_least(1).error_on(:commentable_id)
    end

    it "should not be valid without content" do
      comment = build(:comment, :content => "")
      comment.should_not be_valid
      comment.should have_at_least(1).error_on(:content)
    end

    it "should not be valid without user_id" do
      comment = build(:comment, :user_id => "")
      comment.should_not be_valid
      comment.should have_at_least(1).error_on(:user_id)
    end
  end

  describe "#unread?" do
    before do
      @comment = create(:comment)
    end

    it "returns true if given time is earlier than created_at" do
      @comment.unread?(Time.zone.now - 5.minutes).should be_true
    end

    it "returns false if given time is later than created_at" do
      @comment.unread?(Time.zone.now + 5.minutes).should be_false
    end
  end

  describe ".recent" do
    before do
      (1..5).each do |i|
        instance_variable_set("@comment_#{i}", create(:comment, :commentable_type => "Topic",
                                                                :created_at => Time.zone.now + i.minutes))
      end
    end

    it "returns 5 comments ordered descendingly if no count given" do
      Comment.recent.should eq([@comment_5, @comment_4, @comment_3, @comment_2, @comment_1])
    end

    it "returns n comments ordered descendingly given count" do
      Comment.recent(3).should eq([@comment_5, @comment_4, @comment_3])
    end
    
    it "returns comments for given commentable" do
      project = create(:project)
      comment = create(:comment, :commentable_type => "Project", :commentable_id => project.id, :created_at => Time.zone.now)
      Comment.recent(project).should include(comment)
    end
    
    it "returns comments for given commentables" do
      project = create(:project)
      dataset = create(:dataset, :project => project)
      comment_p = create(:comment, :commentable_type => "Project", :commentable_id => project.id, :created_at => Time.zone.now)
      comment_d = create(:comment, :commentable_type => "Dataset", :commentable_id => dataset.id, :created_at => Time.zone.now)
      recent = Comment.recent([project, dataset])
      recent.should include(comment_p)
      recent.should include(comment_d)
    end
  end

end
