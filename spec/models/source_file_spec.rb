# == Schema Information
#
# Table name: source_files
#
#  id                  :integer(4)      not null, primary key
#  dataset_id          :integer(4)
#  source_file_name    :string(255)
#  source_content_type :string(50)
#  source_file_size    :integer(4)
#  source_updated_at   :datetime
#  status              :string(20)
#  header_rows_count   :integer(4)
#  data_rows_count     :integer(4)
#  imported_at         :datetime
#  error_message       :string(255)
#  error_at            :datetime
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe SourceFile do
  include AttachmentSpecHelper

  before(:all) do
    @user = create(:user)
    @account = @user.account
    @project = create(:project, :account => @account)
    @dataset = create(:dataset, :project => @project)

    @csv_content = <<-EOS
first_name,last_name,value
John,Smith,42
Peter,Johnson,37
EOS
    @xml_content = <<-XML
<persons>
  <person>
    <first_name>John</first_name>
    <last_name>Smith</last_name>
    <value>42</value>
  </person>
  <person>
    <first_name>Peter</first_name>
    <last_name>Johnson</last_name>
    <value>37</value>
  </person>
</persons>
XML
  end

  after(:all) do
    @user.destroy
  end

  describe "validations" do
    it "should not be valid without attachment" do
      source_file = @dataset.source_files.build
      source_file.should_not be_valid
    end

    it "should be valid with attachment" do
      source_file = @dataset.source_files.build(:source => attachment("test.csv", @csv_content))
      source_file.should be_valid
    end

    it "should not be valid with existing file name" do
      @dataset.source_files.create!(:source => attachment("test.csv", @csv_content))
      source_file = @dataset.source_files.build(:source => attachment("test.csv", @csv_content))
      source_file.should_not be_valid
    end
  end

  describe "status" do
    it "initial status should be new" do
      source_file = @dataset.source_files.build
      source_file.status.should == "new"
    end

    it "can start import of CSV file" do
      source_file = @dataset.source_files.create!(:source => attachment("test.csv", @csv_content))
      source_file.can_start_import?.should be_true
    end

    it "cannot start import of XML file" do
      source_file = @dataset.source_files.create!(:source => attachment("test.xml", @xml_content))
      source_file.can_start_import?.should be_false
    end
  end

  describe "preview" do
    def create_source_file(rows, options = {})
      options[:separator] ||= ','
      csv_content = ""
      unless options[:no_header]
        head = (1..rows.first.size).map{|i| "field#{i}"}
        csv_content <<head.to_csv(:col_sep => options[:separator])
      end
      csv_content << rows.map{|r| r.to_csv(:col_sep => options[:separator])}.join
      @source_file = @dataset.source_files.create!(:source => attachment("test.csv", csv_content))
      @preview = @source_file.preview
    end

    describe "date type detection" do
      before(:all) do
        create_source_file [["2012-01-25", "2012.01.25", "25.01.2012", "2012/01/25"]]
      end
      after(:all) do
        @source_file.destroy
      end

      it "should detect date in ISO format" do
        @preview[:columns][0][:data_type].should == :date
        Time.parse(@preview[:rows][0][0]).should == Time.local(2012,01,25)
      end

      it "should detect date in European format" do
        @preview[:columns][1][:data_type].should == :date
        @preview[:columns][2][:data_type].should == :date
        Time.parse(@preview[:rows][0][1]).should == Time.local(2012,01,25)
        Time.parse(@preview[:rows][0][2]).should == Time.local(2012,01,25)
      end

      it "should detect date in USA format" do
        @preview[:columns][3][:data_type].should == :date
        Time.parse(@preview[:rows][0][3]).should == Time.local(2012,01,25)
      end
    end

    describe "datetime type detection" do
      before(:all) do
        create_source_file [["2011-01-25 19:04:05", "2011.01.25 19:04:05", "25.01.2011 19:04:05", "2011/01/25 19:04:05"]]
      end
      after(:all) do
        @source_file.destroy
      end

      it "should detect datetime in ISO format" do
        @preview[:columns][0][:data_type].should == :datetime
        Time.parse(@preview[:rows][0][0]).should == Time.local(2011,01,25,19,04,05)
      end

      it "should detect datetime in European format" do
        @preview[:columns][1][:data_type].should == :datetime
        @preview[:columns][2][:data_type].should == :datetime
        Time.parse(@preview[:rows][0][1]).should == Time.local(2011,01,25,19,04,05)
        Time.parse(@preview[:rows][0][2]).should == Time.local(2011,01,25,19,04,05)
      end

      it "should detect datetime in USA format" do
        @preview[:columns][3][:data_type].should == :datetime
        Time.parse(@preview[:rows][0][3]).should == Time.local(2011,01,25,19,04,05)
      end
    end

    describe "numeric type detection" do
      before(:all) do
        create_source_file [["123456", "123,456", "123456.789", "123,456.789"]]
      end
      after(:all) do
        @source_file.destroy
      end

      it "should detect integer" do
        @preview[:columns][0][:data_type].should == :integer
      end

      it "should detect integer with comma thousands separator" do
        @preview[:columns][1][:data_type].should == :integer
      end

      it "should detect decimal" do
        @preview[:columns][2][:data_type].should == :decimal
        @preview[:columns][2][:scale].should == 3
      end

      it "should detect decimal with comma thousands separator" do
        @preview[:columns][3][:data_type].should == :decimal
        @preview[:columns][3][:scale].should == 3
      end

    end

    describe "type detection with empty values" do
      before(:all) do
        create_source_file [["2011-01-25", "2011-01-25 19:04:05", "123", "123.456", "abc"],["","","","",""]]
      end
      after(:all) do
        @source_file.destroy
      end

      it "should ignore empty values when detecting date type" do
        @preview[:columns][0][:data_type].should == :date
      end

      it "should ignore empty values when detecting datetime type" do
        @preview[:columns][1][:data_type].should == :datetime
      end

      it "should ignore empty values when detecting integer type" do
        @preview[:columns][2][:data_type].should == :integer
      end

      it "should ignore empty values when detecting decimal type" do
        @preview[:columns][3][:data_type].should == :decimal
      end

      it "should ignore empty values when detecting string type" do
        @preview[:columns][4][:data_type].should == :string
      end
    end
  end

end
