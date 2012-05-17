class SourceFilesController < ApplicationController
  before_filter :set_dataset

  def create
    source_file = @dataset.source_files.build(params[:source_file])
    unless source_file.save
      flash[:alert] = source_file.errors.full_messages.join("\n")
    end
    flash[:tab] = 'upload'
    redirect_to dataset_path(@dataset)
  end

  def destroy
    source_file = @dataset.source_files.find(params[:id])
    source_file.destroy_and_delete_data
    flash[:tab] = 'upload'
    redirect_to dataset_path(@dataset)
  end

  def download
    find_source_file_by_name
    send_file @source_file.source.path, :type => @source_file.source_content_type, :disposition => 'attachment'
  end

  def preview
    find_source_file_by_name
    @columns = @source_file.preview[:columns]
    @rows = @source_file.preview[:rows]
    # pass format to override file extension format (e.g. .csv)
    render 'preview', :formats => [:html]
  end

  def start_import
    source_file = @dataset.source_files.find(params[:id])
    if source_file.update_dataset_columns params[:columns]
      source_file.import!
      flash[:tab] = 'upload'
      redirect_to dataset_path(@dataset)
    else
      flash[:alert] = "Could not start file import due to errors:\n" << source_file.dataset.errors.full_messages.join("\n")
      redirect_to source_file_preview_path(source_file)
    end
  end

  private

  def set_dataset
    @account = Account.find_by_login!(params[:account_id])
    @project = if params[:project_id]
      @account.projects.find(params[:project_id])
    elsif params[:project_shortname]
      @account.projects.find_by_shortname!(params[:project_shortname])
    end
    @dataset = if params[:dataset_id]
      @project.datasets.find(params[:dataset_id])
    elsif params[:dataset_shortname]
      @project.datasets.find_by_shortname!(params[:dataset_shortname])
    end
  end

  def find_source_file_by_name
    file_name = params[:file_name]
    file_name += ".#{params[:format]}" if params[:format]
    @source_file = @dataset.source_files.find_by_source_file_name!(file_name)
  end

end