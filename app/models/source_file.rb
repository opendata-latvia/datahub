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

require 'csv'

class SourceFile < ActiveRecord::Base
  belongs_to :dataset

  has_attached_file :source
  validates_attachment_presence :source
  validates_presence_of :dataset_id
  validates_uniqueness_of :source_file_name, :scope => :dataset_id, :message => "should be unique"

  attr_accessible :source

  state_machine :status, :initial => :new do
    state :new
    state :importing
    state :imported
    state :replaced
    state :error

    event :start_import do
      transition [:new, :replaced] => :importing, :if => :file_type_valid?
    end
  end

  scope :recent, order('created_at DESC')

  def preview
    @preview ||= begin
      load_preview_header_and_rows
      {
        :rows => @rows,
        :columns => preview_columns
      }
    end
  end

  AVAILABLE_DATA_TYPES = %w(string integer decimal date datetime)

  def self.available_data_types
    AVAILABLE_DATA_TYPES.map do |data_type|
      [data_type, data_type]
    end
  end

  def update_dataset_columns(column_overrides)
    load_preview_header_and_rows
    columns = preview_columns.map.with_index do |preview_column, i|
      if column_override = column_overrides[i]
        preview_column.merge column_override.symbolize_keys
      else
        preview_column
      end
    end
    dataset.update_columns columns
  end

  def import!
    dataset.create_or_alter_table!
  end

  private

  def file_type_valid?
    source_content_type == 'text/csv'
  end

  PREVIEW_ROWS = 100

  def preview_columns
    Array(@header_rows.first).map.with_index do |header, i|
      {:name => header}.merge(detect_data_type_options(i))
    end
  end

  def detect_data_type_options(i)
    matching_type = {}
    max_scale = nil
    @rows.each do |row|
      value = row[i]
      type_code, scale = detect_value_type(value)
      max_scale = scale if scale && scale > (max_scale||0)
      matching_type[type_code] = true
    end

    options = {
      :data_type => [:string, :decimal, :integer, :date, :datetime].detect{|t| matching_type[t]} || :string
    }
    options[:scale] = max_scale if options[:data_type] == :decimal
    options
  end

  def detect_value_type(value)
    case value
    when Integer, /\A-?[\d, ]+\Z/
      :integer
    when Date,
        /\A\d\d\d\d[.\/\-]\d\d[.\/\-]\d\d\Z/, /\A\d\d\d\d[.\/\-]\d\d[.\/\-]\d\d[ T]00:00:00[ Z]?/,
        /\A\d\d[.\/]\d\d[.\/]\d\d\d\d\Z/, /\A\d\d[.\/]\d\d[.\/]\d\d\d\d[ T]00:00:00[ Z]?/
      :date
    when Time, DateTime,
        /\A\d\d\d\d[.\/\-]\d\d[.\/\-]\d\d[ T]\d\d[.:]\d\d[.:]\d\d[ Z]?/,
        /\A\d\d[.\/]\d\d[.\/]\d\d\d\d[ T]\d\d:\d\d:\d\d[ Z]?/
      :datetime
    when Float, BigDecimal, /\A-?[\d\., ]+\Z/
      value = value.gsub(/[, ]/, '') if value.is_a?(String)
      scale = BigDecimal(value.to_s).to_s('F').split('.')[1].length
      [:decimal, scale]
    when nil, ""
      :empty
    else
      :string
    end
  end

  def load_preview_header_and_rows
    # TODO: support different number of header rows in future
    header_rows_count = 1
    @rows = read_rows :offset => header_rows_count, :limit => PREVIEW_ROWS
    @header_rows = read_rows :limit => header_rows_count
  end

  def read_rows(options)
    file_extension = File.extname(source.original_filename.downcase)
    rows = []
    offset, limit, batch_size = options[:offset], options[:limit], options[:batch_size]
    raise ArgumentError, "Use read_rows with block when providing :batch_size option" if batch_size && !block_given?

    case file_extension
    when '.csv'
      CSV.foreach(source.path, :col_sep => detect_separator(source.path)) do |row|
        next if offset && offset > 0 && (offset -= 1)
        rows << row
        break if limit && (limit -= 1) && limit <= 0
        if batch_size && (batch_size -= 1) && batch_size <= 0
          yield rows
          batch_size = options[:batch_size]
          rows = []
        end
      end
    else
      raise ArgumentError, "Unsupported filename extension: #{file_extension}"
    end

    if block_given? && !rows.empty?
      yield rows
    else
      rows
    end
  end

  def detect_separator(path)
    separator = ','
    File.open(path) do |file|
      line = file.gets
      comma_columns_size = begin
        CSV.parse(line, :col_sep=>',').first.try(:size) || 0
      rescue CSV::MalformedCSVError
        0
      end
      semicolon_columns_size = begin
        CSV.parse(line, :col_sep=>';').first.try(:size) || 0
      rescue CSV::MalformedCSVError
        0
      end
      separator = ';' if semicolon_columns_size > comma_columns_size
    end
    separator
  end

end
