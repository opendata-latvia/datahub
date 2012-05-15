class Dwh < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "#{Rails.env}_dwh"

  def self.drop_all_tables!
    connection.tables.each do |table|
      connection.drop_table table
    end
  end

  DEFAULT_DATA_TYPE_OPTIONS = {
    :string => {:limit => 255},
    :integer => {:limit => 4},
    :decimal => {:precision => 15, :scale => 2}
  }

  def self.default_data_type_options(data_type)
    DEFAULT_DATA_TYPE_OPTIONS[data_type] || {}
  end

  def self.table_exists?(table_name)
    connection.table_exists?(table_name)
  end

  def self.table_columns(table_name)
    if table_exists?(table_name)
      columns = {}
      connection.columns(table_name).each do |column|
        columns[column.name] = options = {
          :data_type => column.type.to_sym
        }
        default_options = default_data_type_options(options[:data_type])
        default_options.each do |key, default_value|
          value = column.send(key)
          options[key] = value unless value == default_value
        end
      end
      columns
    end
  end

  # will return true if table created or altered
  # `columns` is either Hash or Array of columns
  def self.create_or_alter_table(table_name, columns, table_options = {})
    unless table_exists?(table_name)
      connection.create_table table_name, table_options do |t|
        columns.each do |column, options|
          column, options = column[:name], column if options.nil? && column.is_a?(Hash)
          next if options[:remove]
          options = default_data_type_options(options[:data_type].to_sym).merge(options)
          t.column column, options.delete(:data_type).to_sym, options
        end
      end
      true
    else
      existing_columns = table_columns(table_name)
      altered = false
      connection.change_table table_name do |t|
        columns.each do |column, options|
          column, options = column[:name], column if options.nil? && column.is_a?(Hash)
          if existing_columns[column] && options[:remove]
            t.remove column
            altered = true
          elsif !existing_columns[column] && !options[:remove]
            options = default_data_type_options(options[:data_type].to_sym).merge(options)
            t.column column, options.delete(:data_type).to_sym, options
            altered = true
          end
        end
      end
      altered
    end
  end

  def self.drop_table(table_name)
    if table_exists?(table_name)
      connection.drop_table table_name
    end
  end

end
