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
end
