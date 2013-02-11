require "redcarpet"
require "documentation/markdown/base"

module Documentation; end
module Documentation::Markdown; end

class Documentation::Markdown::HTML < Redcarpet::Render::HTML
  include Documentation::Markdown::Base
  include Redcarpet::Render::SmartyPants

  def initialize(options={})
    @custom_options = options

    super({
      filter_html:     true,
      no_images:       false,
      no_links:        false,
      no_styles:       true,
      safe_links_only: false,
      with_toc_data:   true,
      hard_wrap:       false,
      xhtml:           true,
    }.merge(options))
  end


  # Custom Hooks
  # ------------
  def process_code_block(code, language)
    code
  end

  def process_block_annotation(type, body)
    context = Documentation::Markdown::Context.new(self.class, @custom_options)

    %Q[\n<section class="annotation #{type}">\n#{context.render(body).body}</section>\n]
  end

  def process_header(text, slug, header_level)
    %Q[<h#{header_level} id="#{slug}">#{text}</h#{header_level}>]
  end

end
