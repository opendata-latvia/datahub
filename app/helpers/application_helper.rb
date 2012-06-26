module ApplicationHelper

  def top_menu_class(instance)
    'active' if controller.instance_of?(instance)
  end

  def comment_commentable_info(commentable)
    info = ""
    case commentable.class.to_s
    when "Topic"
      info = t("comments.commented_topic")
      info << "&nbsp;"
      info << content_tag(:strong, link_to(commentable.title, forum_topic_path(commentable.forum.slug, commentable.slug)))
    when "Dataset"
      info = t "datasets.commented_dataset"
      info << "&nbsp;"
      info << content_tag(:strong, link_to(commentable.name, dataset_path(commentable)))
    when "Project"
      info = t "projects.commented_project"
      info << "&nbsp;"
      info << content_tag(:strong, link_to(commentable.name, project_path(commentable)))
    else
      commentable.class
    end
    info.html_safe
  end

end
