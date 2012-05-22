class ForumsController < ApplicationController
  before_filter :find_record, :except => [:index, :new, :create]

  def index
    authorize! :read, Forum
    @forums = Forum.all
    # do not expand first forum
    # @forum = @forums.first unless @forum
  end

  def show
    index
    render :index
  end

  def new
    authorize! :create, Forum
    @forum = Forum.new
  end

  def create
    authorize! :create, Forum
    @forum = Forum.new(params[:forum])
    if @forum.save
      redirect_to forum_path(@forum.slug)
    else
      render :action => "new"
    end
  end

  def edit
    authorize! :update, @forum
  end

  def update
    authorize! :update, @forum
    if @forum.update_attributes(params[:forum])
      redirect_to forum_path(@forum.slug)
    else
      render :action => "edit"
    end
  end

  def destroy
    authorize! :destroy, @forum
    @forum.destroy
    redirect_to forums_path
  end

  private

  def find_record
    @forum = Forum.find_by_slug!(params[:id])
  end

end
