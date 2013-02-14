require "set"
require "babosa"

require "documentation/markdown/header_node"
require "documentation/markdown/outline_node"

module Documentation; end
module Documentation::Markdown; end

# Redcarpet hooks and helpers that consume a preprocessed document and render it
# the way we like.
module Documentation::Markdown::Base

  class SyntaxError < TypeError; end

  # Metadata
  # --------

  def metadata
    @metadata ||= {}
  end

  def headers_seen
    @headers_seen ||= Set.new
  end

  def current_toc_stack
    @current_toc_stack ||= [toc_root]
  end

  def toc_root
    @toc_root ||= Documentation::Markdown::HeaderNode.new(nil, nil, 0)
  end

  # Renderers get reused; this is where we set up a blank slate
  def reset_for_reuse!
    @metadata          = nil
    @headers_seen      = nil
    @toc_root          = nil
    @current_toc_stack = nil
  end


  # Required Hooks
  # --------------

  def process_code_block(_code, _language)
    raise NotImplementedError, "#{self.class}#process_code_block is not implemented!"
  end

  def process_block_annotation(_type, _body)
    raise NotImplementedError, "#{self.class}#process_block_annotation is not implemented!"
  end

  def process_header(_text, _slug, _header_level)
    raise NotImplementedError, "#{self.class}#process_header is not implemented!"
  end


  # Optional Hooks
  # --------------

  def process_annotation(type, body)
    body = body.strip

    case type
    when :warning, :todo
      process_block_annotation(type, body)
    when :introduced, :deprecated, :parent, :aliases, :includes
      process_metadata_annotation(type, body)
    else
      process_unknown_annotation(type, body)
    end
  end

  def process_metadata_annotation(type, body)
    if metadata.has_key? type
      warn "Multiple instances of annotation type: #{type.inspect}.  Bashing over previous value: #{metadata[type].inspect} with value: #{body.inspect}"
    end

    metadata[type] = body

    ""
  end

  def process_unknown_annotation(type, body)
    warn "Unknown annotation type: #{type.inspect}, body: #{body.inspect}"

    ""
  end


  # Redcloth Hooks
  # --------------

  def block_code(code, language)
    if language && language.start_with?("annotation:")
      process_annotation(language[11..-1].to_sym, code)
    else
      process_code_block(code, language)
    end
  end

  def header(text, header_level)
    slug = slug_for_header_text(text)

    new_node = Documentation::Markdown::HeaderNode.new(text, slug, header_level)

    # Pop back up to this node's level
    current_toc_stack.slice! header_level..-1
    parent_node = current_toc_stack.last

    unless parent_node.level == new_node.level - 1
      raise SyntaxError, "Header levels must increase linearly.  #{new_node.inspect} skipped one or more levels - parent is #{parent_node.inspect}"
    end

    parent_node.children.push new_node
    current_toc_stack.push    new_node

    process_header(text, slug, header_level)
  end

  def slug_for_header_text(text)
    clean_text = text.gsub(/<[^>]+>/, "").gsub(/([^A-Z])([A-Z]+)/, "\\1-\\2")
    slug_base  = Babosa::Identifier.new(clean_text).normalize.to_s

    slug = slug_base
    i    = 1
    while headers_seen.include? slug
      slug = "#{slug_base}-#{i += 1}"
    end
    headers_seen.add(slug)

    slug
  end

end
