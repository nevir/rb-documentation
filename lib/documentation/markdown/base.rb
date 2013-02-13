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

  # Renderers get reused; this is where we set up a blank slate
  def setup!
    @metadata     = {}
    @headers_seen = Set.new
    @toc_root     = nil

    @current_toc_stack = []
  end

  attr_reader :metadata
  attr_reader :toc_root


  # Required Hooks
  # --------------

  def process_code_block(code, language)
    raise NotImplementedError, "#{self.class}#process_code_block is not implemented!"
  end

  def process_block_annotation(type, body)
    raise NotImplementedError, "#{self.class}#process_block_annotation is not implemented!"
  end

  def process_header(text, slug, header_level)
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
      $stderr.puts "Multiple instances of annotatinon type: #{type.inspect}.  Bashing over previous value: #{metadata[type].inspect}"
    end

    metadata[type] = body

    ""
  end

  def process_unknown_annotation(type, body)
    $stderr.puts "Unknown annotation type: #{type.inspect}, body: #{body.inspect}"

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

    if @toc_root
      append_header(text, slug, header_level)
    else
      assign_toc_root(text, slug, header_level)
    end

    process_header(text, slug, header_level)
  end

  def slug_for_header_text(text)
    clean_text = text.gsub(/<[^>]+>/, "").gsub(/([^A-Z])([A-Z]+)/, "\\1-\\2")
    slug_base  = Babosa::Identifier.new(clean_text).with_separators.normalize.to_s

    slug = slug_base
    i    = 1
    while @headers_seen.include? slug
      slug = "#{slug_base}-#{i += 1}"
    end
    @headers_seen.add(slug)

    slug
  end

  def append_header(text, slug, header_level)
    new_node = Documentation::Markdown::HeaderNode.new(text, slug, header_level)

    # Pop back up to this node's level
    @current_toc_stack.slice! header_level..-1
    parent_node = @current_toc_stack.last

    unless parent_node.level == new_node.level - 1
      raise SyntaxError, "Header levels must increase linearly.  #{new_node.inspect} skipped one or more levels - parent is #{parent_node.inspect}"
    end

    parent_node.children.push new_node
    @current_toc_stack.push   new_node

    new_node
  end

  def assign_toc_root(text, slug, header_level)
    if header_level > 1
      raise SyntaxError, "First header of file MUST be a level one header.  Got #{text.inspect} as a level #{header_level} instead."
    end

    @toc_root    = Documentation::Markdown::HeaderNode.new(nil, nil, 0)
    first_header = Documentation::Markdown::HeaderNode.new(text, slug, header_level)
    @toc_root.children.push first_header

    @current_toc_stack = [@toc_root, first_header]

    @toc_root
  end

end
