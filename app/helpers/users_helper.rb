module UsersHelper

  def current_user_avatar_and_name
    html = gravatar_image_tag(current_user.email, :gravatar => {:size => 20})
    html << raw("&nbsp;<strong>#{h current_user.display_name}</strong>")
    html
  end


end