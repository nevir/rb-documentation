module Documentation; end
module Documentation::Markdown; end

# A very simple representation for a header in a table of contents or outline.
class Documentation::Markdown::HeaderNode

  def initialize(title, slug, level)
    @title    = title
    @slug     = slug
    @level    = level
    @children = []
  end

  attr_accessor :title
  attr_accessor :level
  attr_accessor :children

end
