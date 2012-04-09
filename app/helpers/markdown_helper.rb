module MarkdownHelper
  def markdown(text)
    text && format_hint_external_links(Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true).render(text))
  end

  # add target="_blank" to outside urls
  def format_hint_external_links(html)
    html.gsub(/href="http/i, 'target="_blank" href="http').html_safe
  end

end
