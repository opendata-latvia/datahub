class ForumsController < ApplicationController
  before_filter :find_record, :except => [:index, :new, :create]
  before_filter :must_be_super_admin, :except => [:index, :show]
  
  def index
    @forums = Forum.all
    @forum = @forums.first unless @forum
  end
  
  def show
    index
    render :index
  end
  
  def new
    @forum = Forum.new
  end
  
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      redirect_to forum_path(@forum.slug), :notice => "Forum #{@forum.title} successfully created"
    else
      render :action => "new"
    end
  end
  
  def edit
  end
  
  def update
    if @forum.update_attributes(params[:forum])
      redirect_to forum_path(@forum.slug), :notice => "Forum #{@forum.title} successfully updated"
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @forum.destroy
    redirect_to forums_path, :notice => "Forum #{@forum.title} successfully deleted"
  end
  
  private
  
  def find_record
    @forum = Forum.find_by_slug!(params[:id])
  end
  
end
