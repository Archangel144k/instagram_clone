module ApplicationHelper
  # Other helper methods...

  # This method converts hashtags in text to clickable links
  def auto_link_hashtags(text)
    return "" if text.blank?
    
    text.to_s.gsub(/#(\w+)/) do |match|
      tag = $1
      link_to(match, tag_path(tag), class: "text-teal-400 hover:underline")
    end.html_safe
  end
end
