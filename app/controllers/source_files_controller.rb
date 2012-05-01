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
    source_file.destroy
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
    render 'preview.html'
  end

  def start_import
    source_file = @dataset.source_files.find(params[:id])
    source_file.start_import!
    flash[:tab] = 'upload'
    redirect_to dataset_path(@dataset)
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