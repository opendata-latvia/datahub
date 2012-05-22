module CommentsHelper
  
  def comments_for(commentable, options = {})
    render :template => "comments/_comments", :locals => {:commentable => commentable, :options => options}
  end
  
  def comments_list(messages)
    messages.map do |message, sub_messages|
      render(:template => "comments/_comment", :locals => {:commentable => message.commentable, :comment => message}) + content_tag(:div, comments_list(sub_messages), :class => "comment-replies", :id => "comment-replies#{message.id}")
    end.join.html_safe
  end
  
  def comment_form(comment_or_commentable)
    if comment_or_commentable.is_a?(Comment)
      comment = comment_or_commentable
    else
      comment = Comment.new(:commentable_type => comment_or_commentable.class.to_s, :commentable_id => comment_or_commentable.id)
    end
    render :template => "comments/_form", :locals => {:comment => comment}
  end
  
  def commentable_comments_id(commentable)
    "#{commentable.class}-#{commentable.id}-comments"
  end
  
  def comment_delete_action(comment)
    if can?(:destroy, comment)
      link_to t("actions.delete"), comment_path(comment), :method => :delete, :remote => true, :class => "btn btn-mini btn-danger",
        :confirm => t("comments.delete_confirm")
    end
  end
  
  def commentable_prompt(comment)
    comment.commentable.respond_to?(:prompt) ? comment.commentable.prompt : "#{comment.commentable_id}-#{comment.commentable_type}"
  end
  
  def comment_link_to_commentable(comment)
    if respond_to?("url_for_#{comment.commentable_type.tableize.singularize}")
      link_to commentable_prompt(comment), send("url_for_#{comment.commentable_type.tableize.singularize}",comment.commentable)
    else
      commentable_prompt(comment)
    end
  end

end
