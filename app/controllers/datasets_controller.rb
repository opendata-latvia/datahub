class DatasetsController < ApplicationController
  before_filter :set_project, :except => :index

  def index
    @datasets = Dataset.search(params)
  end

  def show
    @dataset = @project.datasets.find_by_shortname!(params[:shortname])
    authorize! :read, @dataset

    case format = params[:format]
    when 'csv'
      send_data @dataset.data_download(params),
        :type => 'text/csv', :filename => "#{@dataset.shortname}.#{format}", :disposition => 'attachment'
    when 'json'
      render :json => @dataset.data_download(params)
    else
      # default HTML rendering
    end
  end

  def datatable
    @dataset = @project.datasets.find_by_shortname!(params[:shortname])
    authorize! :read, @dataset
    respond_to do |format|
      format.json do
        render :json => DatasetDatatable.new(@dataset, view_context)
      end
    end
  end

  def new
    authorize! :create_dataset, @project
    @dataset = @project.datasets.build
  end

  def create
    authorize! :create_dataset, @project
    @dataset = @project.datasets.build dataset_attributes
    if @dataset.save
      redirect_to dataset_path(@dataset)
    else
      render 'new'
    end
  end

  def edit
    @dataset = @project.datasets.find(params[:id])
    authorize! :update, @dataset
  end

  def update
    @dataset = @project.datasets.find(params[:id])
    authorize! :update, @dataset
    if @dataset.update_attributes dataset_attributes
      redirect_to dataset_path(@dataset)
    else
      render 'edit'
    end
  end

  def delete_columns
    @dataset = @project.datasets.find(params[:id])
    authorize! :update, @dataset
    unless @dataset.delete_columns
      flash[:alert] = t 'datasets.errors.cannot_delete_all_columns'
    end
    flash[:tab] = 'columns'
    redirect_to dataset_path(@dataset)
  end

  def destroy
    @dataset = @project.datasets.find(params[:id])
    authorize! :destroy, @dataset
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
