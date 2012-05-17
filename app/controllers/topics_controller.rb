class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :find_forum
  before_filter :find_topic, :except => [:new, :create]

  def new
    authorize! :create, Topic
    @topic = Topic.new(:commentable => true)
  end

  def create
    authorize! :create, Topic
    @topic = @forum.topics.build(params[:topic])
    @topic.user_id = current_user.id
    if @topic.save
      redirect_to forum_topic_path(@forum.slug, @topic.slug), :notice => "Topic #{@topic.title} successfully created"
    else
      render :action => "new"
    end
  end

  def show
    authorize! :read, @topic
  end

  def edit
    authorize! :update, @topic
  end

  def update
    authorize! :update, @topic
    if @topic.update_attributes(params[:topic])
      redirect_to forum_topic_path(@forum.slug, @topic.slug), :notice => "Topic #{@topic.title} successfully updated"
    else
      render :action => "edit"
    end
  end

  def destroy
    authorize! :destroy, @topic
    @topic.destroy
    redirect_to forum_path(@forum.slug), :notice => "Topic #{@topic.title} successfully deleted"
  end

  private

  def find_forum
    @forum = Forum.find_by_slug!(params[:forum_id])
  end

  def find_topic
    @topic = @forum.topics.find_by_slug!(params[:id])
  end

end
