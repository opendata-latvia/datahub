require 'spec_helper'

describe SourceFile do
  include AttachmentSpecHelper

  before(:each) do
    @user = create(:user)
    @account = @user.account
    @project = create(:project, :account => @account)
    @dataset = create(:dataset, :project => @project)

    @csv_content = <<-EOS
first_name,last_name,value
John,Smith,42
Peter,Johnson,37
EOS
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
  end

end
