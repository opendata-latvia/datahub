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

  def dataset_info(dataset)
    info = []
    if (source_files_size = dataset.source_files.size) > 0
      info << t("datasets.source_files_uploaded", :count => source_files_size)
    end
    info << t("datasets.comments", :count => dataset.comments.count) if dataset.any_comment?
    info.join(', ')
  end
end