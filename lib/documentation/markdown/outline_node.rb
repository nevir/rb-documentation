module Documentation; end
module Documentation::Markdown; end

# A very simple representation for a single element of an outline
class Documentation::Markdown::OutlineNode

  def initialize(title, level, target)
    @title    = title
    @level    = level
    @target   = target
    @children = []
  end

  attr_accessor :title
  attr_accessor :level
  attr_accessor :target
  attr_accessor :children

end
