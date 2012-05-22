module DatasetsHelper
  def dataset_column_display_limit(column)
    case column[:data_type]
    when :string
      limit = column[:limit] || Dwh.default_data_type_options(:string)[:limit]
      t "datasets.show.columns.display_limit.string", :limit => limit
    when :decimal
      options = column.merge Dwh.default_data_type_options(:decimal)
      t "datasets.show.columns.display_limit.decimal", options.slice(:precision, :scale)
    end
  end
end