require "forwardable"
require "documentation/context"

module Documentation
  DOC_ROOT = File.expand_path("../../documentation", __FILE__)

  def self.context_for(lang, options={})
    Documentation::Context.new(DOC_ROOT, lang, options)
  end

end
