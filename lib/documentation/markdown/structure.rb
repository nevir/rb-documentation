require "redcarpet"
require "documentation/markdown/base"

module Documentation; end
module Documentation::Markdown; end

class Documentation::Markdown::Structure < Redcarpet::Render::Base
  include Documentation::Markdown::Base

  def preprocess(body)
    body
  end

  def method_missing(sym, *args)
    puts "#{sym}(#{args.map(&:inspect).join(", ")})"

    ""
  end

  def respond_to?(sym)
    true
  end


  def codespan(code)
    code
  end

end
