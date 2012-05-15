# encoding: utf-8
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
  before(:all) do
    @user = create(:user)
    @account = @user.account
    @project = create(:project, :account => @account)

    @columns = [
      {:name => 'Name', :data_type => :string},
      {:name => 'Units', :data_type => :integer},
      {:name => 'Price', :data_type => :decimal, :scale => 4},
      {:name => 'Exipres on', :data_type => :date},
      {:name => 'Created at', :data_type => :datetime}
    ]
    @expected_columns = @columns.map do |column|
      column.merge(:column_name => column[:name].downcase.gsub(' ', '_'))
    end
  end

  after(:all) do
    @project.destroy
    @user.destroy
  end

  describe "validations" do
    before(:all) do
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

  describe "columns" do
    before(:each) do
      @dataset = create(:dataset, :project => @project)
    end

    it "should update columns" do
      @dataset.update_columns(@columns).should be_true
      @dataset.columns.should == @expected_columns
    end

    it "should update existing column" do
      @dataset.update_columns(@columns)
      @dataset.update_columns([@columns.first]).should be_true
      @dataset.columns.should == @expected_columns
    end

    it "should add new column" do
      @dataset.update_columns(@columns)
      new_column = {
        'name' => 'Dummy, āčē',
        'data_type' => 'string'
      }
      @dataset.update_columns([new_column]).should be_true
      @dataset.columns.should == @expected_columns + [{
        :name => 'Dummy, āčē',
        :column_name => 'dummy__ace',
        :data_type => :string
      }]
    end
  end

  describe "table" do
    before(:each) do
      @dataset = create(:dataset, :project => @project)
      @dataset.update_columns @columns
      @dataset.create_or_alter_table!
    end

    after(:each) do
      # to ensure droping of table
      @dataset.destroy
    end

    it "should create new dataset table" do
      @dataset.table_name.should == "dataset_#{@dataset.id}"
      @dataset.table_exists?.should be_true
    end

    it "should create table with dataset columns" do
      Dwh.table_columns(@dataset.table_name).should == @expected_columns.inject({}){|h, c| h[c[:column_name]] = c.except(:name, :column_name); h}
    end

    it "should drop dataset table when dataset is destroyed" do
      @dataset.destroy
      Dwh.table_exists?(@dataset.table_name).should be_false
    end
  end

end
