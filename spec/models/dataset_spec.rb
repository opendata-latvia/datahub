# == Schema Information
#
# Table name: datasets
#
#  id             :integer(4)      not null, primary key
#  project_id     :integer(4)      not null
#  shortname      :string(40)      not null
#  name           :string(255)     not null
#  description    :text
#  source_url     :string(255)
#  columns        :text
#  last_import_at :datetime
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe Dataset do
  describe "validations" do
    before(:each) do
      @user = create(:user)
      @account = @user.account
      @project = create(:project, :account => @account)

      @valid_attributes = {
        :name => "Test dataset",
        :shortname => "test-dataset"
      }
    end

    it "should be valid with valid attributes" do
      @project.datasets.build(@valid_attributes).should be_valid
    end

    it "should not be valid without name" do
      dataset = @project.datasets.build(@valid_attributes.except(:name))
      dataset.should have_at_least(1).error_on(:name)
    end

    it "should not be valid without shortname" do
      dataset = @project.datasets.build(@valid_attributes.except(:shortname))
      dataset.should have_at_least(1).error_on(:shortname)
    end

    it "should not be valid with invalid shortname" do
      dataset = @project.datasets.build(@valid_attributes.merge(:shortname => "test dataset"))
      dataset.should have_at_least(1).error_on(:shortname)
    end

    it "should not be valid with duplicate shortname" do
      dataset = @project.datasets.create(@valid_attributes)
      dataset2 = @project.datasets.build(@valid_attributes.merge(:name => "Test dataset 2"))
      dataset2.should have_at_least(1).error_on(:shortname)
    end

  end

end
