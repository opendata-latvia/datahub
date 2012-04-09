module ProjectPathHelper
  def project_path(project)
    project_profile_path(project.account, project.shortname)
  end

  def dataset_path(dataset)
    dataset_profile_path(dataset.project.account, dataset.project.shortname, dataset.shortname)
  end

end