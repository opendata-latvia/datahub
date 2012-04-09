class ProjectsController < ApplicationController
  before_filter :set_account

  def show
    @project = @account.projects.find_by_shortname!(params[:shortname])
  end

  def new
    @project = @account.projects.build
  end

  def create
    @project = @account.projects.build project_attributes
    if @project.save
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  def edit
    @project = @account.projects.find(params[:id])
  end

  def update
    @project = @account.projects.find(params[:id])
    if @project.update_attributes project_attributes
      redirect_to project_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @project = @account.projects.find(params[:id])
    @project.destroy
    redirect_to account_profile_path(@account)
  end

  private

  def set_account
    @account = Account.find_by_login!(params[:account_id])
  end

  def project_attributes
    params[:project].slice(
      :name, :shortname, :description, :homepage
    )
  end

end
