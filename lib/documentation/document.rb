module Documentation; end

class Documentation::Document

  def initialize(rendered_source, toc_root, metadata={})
    @rendered_source = rendered_source
    @toc_root        = toc_root
    @metadata        = metadata
  end

  attr_reader :rendered_source
  attr_reader :toc_root
  attr_reader :metadata

end
