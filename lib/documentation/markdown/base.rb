require "set"
require "babosa"

module Documentation; end
module Documentation::Markdown; end

# Redcarpet hooks and helpers that consume a preprocessed document and render it
# the way we like.
module Documentation::Markdown::Base

  # Metadata
  # --------

  def metadata
    @metadata ||= {}
  end

  def headers_seen
    @headers_seen ||= Set.new
  end

  # Renderers get reused; this is where we clear our custom state
  def reset!
    @metadata     = nil
    @headers_seen = nil
  end


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
    clean_text = text.gsub(/<[^>]+>/, "").gsub(/([^A-Z])([A-Z]+)/, "\\1-\\2")
    slug_base  = Babosa::Identifier.new(clean_text).with_separators.normalize.to_s

    slug = slug_base
    i    = 1
    while headers_seen.include? slug
      slug = "#{slug_base}-#{i += 1}"
    end
    headers_seen.add(slug)

    process_header(text, slug, header_level)
  end

end
