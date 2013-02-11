require "redcarpet"
require "documentation/markdown/preprocessing"

module Documentation; end
module Documentation::Markdown; end

class Documentation::Markdown::Context < Redcarpet::Markdown

  # We extend redcarpet's render result to contain additional metadata.
  Result = Struct.new(:body, :metadata)

  # Options accept both `Redcarpet::Markdown` AND renderer options; there isn't
  # any overlap currently, or in the foreseeable future.
  #
  # Redcarpet does not implement `initialize`, so we're stuck overriding `new`.
  def self.new(renderer_class, options={})
    super(renderer_class.new(options), {
      no_intra_emphasis:   true,
      tables:              true,
      fenced_code_blocks:  true,
      autolink:            true,
      strikethrough:       true,
      lax_spacing:         false,
      space_after_headers: true,
      superscript:         true,
    }.merge(options))
  end

  def render(body, options={})
    unless options[:preprocessed]
      Documentation::Markdown::Preprocessing.preprocess! body
    end

    Result.new.tap do |result|
      result.body     = super(body)
      result.metadata = @renderer.metadata

      @renderer.reset!
    end
  end

end
