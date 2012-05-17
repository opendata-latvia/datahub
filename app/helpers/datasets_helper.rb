module DatasetsHelper
  def dataset_column_display_limit(column)
    case column[:data_type]
    when :string
      limit = column[:limit] || Dwh.default_data_type_options(:string)[:limit]
      "#{limit} characters"
    when :decimal
      options = column.merge Dwh.default_data_type_options(:decimal)
      "#{options[:precision]} digits, #{options[:scale]} after decimal point"
    end
  end
end