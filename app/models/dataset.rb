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

class Dataset < ActiveRecord::Base
  belongs_to :project
  has_many :source_files, :dependent => :destroy

  validates_presence_of :name, :shortname
  validates_length_of :shortname, :within => 4..40
  validates_format_of :shortname, :with => User::VALID_URL_COMPONENT_REGEXP
  validates_uniqueness_of :shortname, :scope => :project_id

  attr_accessible :shortname, :name, :description, :source_url

  serialize :columns

  after_destroy :drop_table

  def update_columns(new_columns)
    columns_will_change!
    self.columns ||= []
    Array(new_columns).each_with_index do |new_column, i|
      new_column = new_column.symbolize_keys
      if new_column[:name].blank?
        errors.add :base, "Column #{i+1} does not have column name"
        return false
      elsif new_column[:data_type].blank?
        errors.add :base, "Column #{new_column[:name]} does not have data type"
        return false
      end
      unless columns.any?{|c| c[:name] == new_column[:name]}
        new_column[:data_type] = new_column[:data_type].to_sym
        columns << new_column.slice(:name, :data_type, :limit, :precision, :scale)
      end
    end
    save
  end

  def table_name
    @table_name ||= "dataset_#{id}"
  end

  def table_exists?
    Dwh.table_exists? table_name
  end

  def create_or_alter_table!
    raise ArgumentError, "Cannot create dataset table without columns" if columns.blank?
    Dwh.create_or_alter_table table_name, columns, :id => false
  end

  def drop_table
    Dwh.drop_table table_name
  end

end
