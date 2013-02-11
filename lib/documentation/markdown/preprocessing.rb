module Documentation; end
module Documentation::Markdown; end

# Common preprocessing for any Markdown renderer.
module Documentation::Markdown::Preprocessing
  INDENTATION_MATCHER = /^( {2,})/

  ANNOTATION_MATCHER = /
    # The tag must be at the start of a line, be 3 or more characters, and be
    # followed by a colon.
    ^([A-Z_]{3,}):
    # Grab any content immediately following the tag, or on following lines...
    (.*?)
    # ...only if they are indented.
    (?=\n\S)
  /xm

  # Preprocess documentation source.
  #
  # Modifies the document in place.
  def self.preprocess!(full_document)
    preprocess_annotations! full_document
    preprocess_indentation! full_document
  end

  # Allow for 2-space indents by multiplying the input spaces
  def self.preprocess_indentation!(full_document)
    full_document.gsub! INDENTATION_MATCHER, "\\1\\1"
  end

  # Convert all annotations into code blocks, using the language to indicate the
  # annotation tag. Each annotation ends up like:
  #
  # ```annotation:tag_name
  # Annotation body goes here.
  # ```
  def self.preprocess_annotations!(full_document)
    full_document.gsub! ANNOTATION_MATCHER do
      # It'd be really nice if `gsub` just passed a `MatchData` instead of the
      # matching `String`...
      tag_name  = $1
      body_text = $2

      # Remove indentation from the body text, if any.
      min_indent = body_text.scan(INDENTATION_MATCHER).map { |m| m[0].length }.min || 0
      if min_indent > 0
        body_text.gsub! /^( {#{min_indent}})/, ""
      end
      body_text.strip!

      "```annotation:#{tag_name.downcase}\n#{body_text}\n```\n"
    end
  end
end
