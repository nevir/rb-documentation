require "documentation/context"

module Documentation

  DOC_ROOT = File.expand_path("../../documentation", __FILE__)

  # See [`Documentation::Context`](documentation/context.rb) for a full
  # reference of context methods.
  def self.default_context
    @default_context ||= context_for(:en)
  end

  def self.context_for(lang, options={})
    Documentation::Context.new(DOC_ROOT, lang, options)
  end

end
