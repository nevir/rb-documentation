require "redcarpet"

require "documentation/document"
require "documentation/errors"
require "documentation/markdown/html"
require "documentation/markdown/preprocessing"

module Documentation; end

class Documentation::Context

  # Options accept both `Redcarpet::Markdown` AND renderer options; there isn't
  # any overlap currently, or in the foreseeable future.
  def initialize(root_path, lang, options={})
    @root_path = root_path
    @lang      = lang
    @format    = options[:format] ? options[:format].to_sym : :html

    @renderer = case @format
    when :html then Documentation::Markdown::HTML.new(options)
    else raise TypeError, "Unknown format #{options[:format].inspect}"
    end

    @redcarpet = Redcarpet::Markdown.new(@renderer, {
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

  attr_reader :root_path
  attr_reader :lang
  attr_reader :format

  # Returns the document at the given path.
  def document(path)
    begin
      target_path = File.join(root_path, lang.to_s, doc_to_fs_path(path))
      doc_file = open(target_path, "r")
    rescue Errno::ENOENT
      raise Documentation::DocumentNotFoundError, "No such document: #{path.inspect}, lang: #{lang} (filesystem: #{target_path.inspect})"
    end

    body = doc_file.read
    Documentation::Markdown::Preprocessing.preprocess! body

    @renderer.reset_for_reuse!
    rendered_source = @redcarpet.render(body)

    Documentation::Document.new(rendered_source, @renderer.toc_root)
  end

  def root
    @root ||= document("")
  end

  # Converts a document path to a filesystem (relative) path.
  def doc_to_fs_path(doc_path)
    if doc_path.end_with?("/") || doc_path == ""
      "#{doc_path}README.md"
    else
      "#{doc_path}.md"
    end
  end

  # Converts a file system (relative) path to a document path.
  def fs_to_doc_path(fs_path)
    fs_path.gsub /(README)?\.md$/, ""
  end

end
