class DatasetsController < ApplicationController
  before_filter :set_project

  def show
    @dataset = @project.datasets.find_by_shortname!(params[:id])
  end

  def new
    @dataset = @project.datasets.build
  end

  def create
    @dataset = @project.datasets.build dataset_attributes
    if @dataset.save
      redirect_to project_path(@account, @project)
    else
      render 'new'
    end
  end

  def edit
    @dataset = @project.datasets.find_by_shortname!(params[:id])
  end

  def update
    @dataset = @project.datasets.find_by_shortname!(params[:id])
    if @dataset.update_attributes dataset_attributes
      redirect_to project_path(@account, @project)
    else
      render 'edit'
    end
  end

  def destroy
    @dataset = @project.datasets.find_by_shortname!(params[:id])
    @dataset.destroy
    redirect_to project_path(@account, @project)
  end

  private

  def set_project
    @account = Account.find_by_login!(params[:account_id])
    @project = @account.projects.find_by_shortname!(params[:project_id])
  end

  def dataset_attributes
    params[:dataset].slice(:name, :shortname, :description, :source_url)
  end

end
