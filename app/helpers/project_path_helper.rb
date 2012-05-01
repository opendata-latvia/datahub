module ProjectPathHelper
  def project_path(project)
    project_profile_path(project.account, project.shortname)
  end

  def dataset_path(dataset)
    dataset_profile_path(dataset.project.account, dataset.project.shortname, dataset.shortname)
  end

  def source_file_download_path(source_file)
    dataset = source_file.dataset
    dataset_source_file_download_path(dataset.project.account, dataset.project.shortname, dataset.shortname, source_file.source_file_name)
  end

  def source_file_preview_path(source_file)
    dataset = source_file.dataset
    dataset_source_file_preview_path(dataset.project.account, dataset.project.shortname, dataset.shortname, source_file.source_file_name)
  end

end