class MarkdownInput < SimpleForm::Inputs::TextInput
  enable :postfix => true
  
  def input
    postfix = options.delete(:postfix) || attribute_name
    input_html_options[:class] << "text wmd-input"
    input_html_options[:id] = "wmd-input#{postfix}"
    template.content_tag(:div, :class => "wmd-panel", :data => {:wmd => postfix}) do
      template.concat(template.content_tag(:div, "",:class => "wmd-button-bar", :id => "wmd-button-bar#{postfix}"))
      template.concat("#{@builder.text_area(attribute_name, input_html_options)}".html_safe)
      template.concat(template.content_tag(:div, "",:class => "wmd-preview", :id => "wmd-preview#{postfix}"))
    end
    
  end
  
end