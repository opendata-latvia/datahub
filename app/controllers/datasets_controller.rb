class DatasetsController < ApplicationController
  before_filter :set_project

  def show
    @dataset = @project.datasets.find_by_shortname!(params[:shortname])
  end

  def datatable
    @dataset = @project.datasets.find_by_shortname!(params[:shortname])
    respond_to do |format|
      format.json do
        render :json => DatasetDatatable.new(@dataset, view_context)
      end
    end
  end

  def new
    @dataset = @project.datasets.build
  end

  def create
    @dataset = @project.datasets.build dataset_attributes
    if @dataset.save
      redirect_to dataset_path(@dataset)
    else
      render 'new'
    end
  end

  def edit
    @dataset = @project.datasets.find(params[:id])
  end

  def update
    @dataset = @project.datasets.find(params[:id])
    if @dataset.update_attributes dataset_attributes
      redirect_to dataset_path(@dataset)
    else
      render 'edit'
    end
  end

  def delete_columns
    @dataset = @project.datasets.find(params[:id])
    unless @dataset.delete_columns
      flash[:alert] = 'Could not delete all columns'
    end
    flash[:tab] = 'columns'
    redirect_to dataset_path(@dataset)
  end

  def destroy
    @dataset = @project.datasets.find(params[:id])
    @dataset.destroy
    redirect_to project_path(@project)
  end

  private

  def set_project
    @account = Account.find_by_login!(params[:account_id])
    @project = if params[:project_id]
      @account.projects.find(params[:project_id])
    elsif params[:project_shortname]
      @account.projects.find_by_shortname!(params[:project_shortname])
    end
  end

  def dataset_attributes
    params[:dataset].slice(:name, :shortname, :description, :source_url)
  end

end
