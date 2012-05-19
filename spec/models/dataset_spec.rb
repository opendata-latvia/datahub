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
      Dwh.table_columns(@dataset.table_name).should ==
        @expected_columns.inject({}){|h, c| h[c[:column_name]] = c.except(:name, :column_name); h}.merge(
          '_source_type' => {:data_type => :string, :limit => 20},
          '_source_name' => {:data_type => :string, :limit => 100},
          '_source_id' => {:data_type => :integer}
        )
    end

    it "should drop dataset table when dataset is destroyed" do
      @dataset.destroy
      Dwh.table_exists?(@dataset.table_name).should be_false
    end

    it "should drop dataset table when all columns are deleted" do
      @dataset.delete_columns.should be_true
      @dataset.columns.should be_nil
      Dwh.table_exists?(@dataset.table_name).should be_false
    end
  end

  describe "query" do
    it "should parse one term query" do
      query = Dataset::Query.new('foo')
      query.parts.should == [[:contains, :any, 'foo']]
    end

    it "should parse one term with national characters" do
      query = Dataset::Query.new('aābcč')
      query.parts.should == [[:contains, :any, 'aābcč']]
    end

    it "should parse two terms" do
      query = Dataset::Query.new('foo bar')
      query.parts.should == [
        [:contains, :any, 'foo'],
        [:contains, :any, 'bar']
      ]
    end

    it "should parse attribute with term" do
      query = Dataset::Query.new('name:foo')
      query.parts.should == [[:contains, 'name', 'foo']]
    end

    it "should parse attribute with term and simple term" do
      query = Dataset::Query.new('name:foo bar')
      query.parts.should == [
        [:contains, 'name', 'foo'],
        [:contains, :any, 'bar']
      ]
    end

    it "should parse quoted term" do
      query = Dataset::Query.new('"foo bar"')
      query.parts.should == [[:contains, :any, 'foo bar']]
    end

    it "should parse term in single quotes" do
      query = Dataset::Query.new("'foo \"bar\"'")
      query.parts.should == [[:contains, :any, 'foo "bar"']]
    end

    it "should parse quoted term containing doubled quotes" do
      query = Dataset::Query.new('"foo ""bar"""')
      query.parts.should == [[:contains, :any, 'foo "bar"']]
    end

    it "should parse quoted attribute and quoted term" do
      query = Dataset::Query.new('"first name":"foo bar"')
      query.parts.should == [[:contains, 'first name', 'foo bar']]
    end

    it "should parse attribute and term in single quotes" do
      query = Dataset::Query.new("'\"first\" name':'foo \"bar\"'")
      query.parts.should == [[:contains, '"first" name', 'foo "bar"']]
    end

    it "should parse quoted attribute and quoted term containing doubled quotes" do
      query = Dataset::Query.new('"""first"" name":"foo ""bar"""')
      query.parts.should == [[:contains, '"first" name', 'foo "bar"']]
    end

    it "should parse attribute equals with term" do
      query = Dataset::Query.new('name=foo')
      query.parts.should == [[:"=", 'name', 'foo']]
    end

    it "should parse attribute greater than term" do
      query = Dataset::Query.new('name>foo')
      query.parts.should == [[:>, 'name', 'foo']]
    end

    it "should parse attribute greater than or equals with term" do
      query = Dataset::Query.new('name>=foo')
      query.parts.should == [[:>=, 'name', 'foo']]
    end

    it "should parse attribute less than term" do
      query = Dataset::Query.new('name<foo')
      query.parts.should == [[:<, 'name', 'foo']]
    end

    it "should parse attribute less than or equals with term" do
      query = Dataset::Query.new('name<=foo')
      query.parts.should == [[:<=, 'name', 'foo']]
    end

    it "should parse attribute not equals with term" do
      query = Dataset::Query.new('name!=foo')
      query.parts.should == [[:"!=", 'name', 'foo']]
    end

  end

end
