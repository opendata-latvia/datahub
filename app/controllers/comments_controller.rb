class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :create, Comment
    @comment = Comment.new(params[:comment])
  end

  def create
    authorize! :create, Comment
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    if @comment.save
      @comment.commentable.touch
      @commentable = @comment.commentable
    else
      flash.now[:alert]= @comment.errors.full_messages.join
      render "_errors"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy
    @comment.commentable.touch
  end
end
