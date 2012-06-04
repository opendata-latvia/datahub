# == Schema Information
#
# Table name: projects
#
#  id          :integer(4)      not null, primary key
#  account_id  :integer(4)      not null
#  shortname   :string(40)      not null
#  name        :string(255)     not null
#  description :text
#  homepage    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Project do
  describe "validations" do
    before(:each) do
      @user = create(:user)
      @account = @user.account

      @valid_attributes = {
        :name => "Test project",
        :shortname => "test-project"
      }
    end

    it "should be valid with valid attributes" do
      @account.projects.build(@valid_attributes).should be_valid
    end

    it "should not be valid without name" do
      project = @account.projects.build(@valid_attributes.except(:name))
      project.should have_at_least(1).error_on(:name)
    end

    it "should not be valid without shortname" do
      project = @account.projects.build(@valid_attributes.except(:shortname))
      project.should have_at_least(1).error_on(:shortname)
    end

    it "should not be valid with invalid shortname" do
      project = @account.projects.build(@valid_attributes.merge(:shortname => "test project"))
      project.should have_at_least(1).error_on(:shortname)
    end

    it "should not be valid with duplicate shortname" do
      project = @account.projects.create(@valid_attributes)
      project2 = @account.projects.build(@valid_attributes.merge(:name => "test project 2"))
      project2.should have_at_least(1).error_on(:shortname)
    end

  end

  describe "search" do
    before(:all) do
      Project.destroy_all
    end

    before(:each) do
      @project_foo_bar = create(:project, :name => "foo bar", :description => "lorem ipsum")
    end

    it "should return all projects when no search query" do
      Project.search(:q => "").should == Project.all
    end

    it "should return projects with matching name" do
      Project.search(:q => "foo").should == [@project_foo_bar]
    end

    it "should not return any project when no matching name" do
      Project.search(:q => "baz").should be_empty
    end

    it "should return projects with several matching terms" do
      Project.search(:q => "bar foo").should == [@project_foo_bar]
    end

    it "should not return projects with matching and not matching terms" do
      Project.search(:q => "foo baz").should be_empty
    end

    it "should return projects with matching description" do
      Project.search(:q => "lorem").should == [@project_foo_bar]
    end

  end

end
