class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :find_forum
  before_filter :find_topic, :except => [:new, :create]
  before_filter :must_be_super_admin, :only => [:destroy]
  
  def new
    @topic = Topic.new(:commentable => true)
  end
  
  def create
    @topic = @forum.topics.build(params[:topic])
    @topic.user_id = current_user.id
    if @topic.save
      redirect_to forum_topic_path(@forum.slug, @topic.slug), :notice => "Topic #{@topic.title} successfully created"
    else
      render :action => "new"
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @topic.update_attributes(params[:topic])
      redirect_to forum_topic_path(@forum.slug, @topic.slug), :notice => "Topic #{@topic.title} successfully updated"
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @topic.destroy
    redirect_to forum_path(@forum.slug), :notice => "Topic #{@topic.title} successfully deleted"
  end
  
  private
  
  def find_forum
    @forum = Forum.find_by_slug!(params[:forum_id])
  end
  
  def find_topic
    @topic = @forum.topics.find_by_slug!(params[:id])
    must_be_owner_or_admin unless %w(new create show).include?(params[:action])
  end
  
  def must_be_owner_or_admin
    authorize! :manage, @topic
  end
end
