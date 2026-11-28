module ApplicationHelper
  def page_title(title = '')
    base_title = 'Archime'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def full_title(page_title = '')
    base_title = "Archime"
    page_title.present? ? "#{page_title} | #{base_title}" : base_title
  end
end
