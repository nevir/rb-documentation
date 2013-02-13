class Stuff < Thor

  desc "do", "stuff"
  def do
    $LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
    require "documentation/markdown/context"
    require "documentation/markdown/html"
    require "yaml"

    m = Documentation::Markdown::Context.new(Documentation::Markdown::HTML)

    result = m.render(open("documentation/en/core/basic_object/README.md").read)
    puts "=" * 80
    puts result.body
    puts "=" * 80
    puts result.metadata.inspect
    puts "=" * 80
    puts result.toc_root.to_yaml
    puts "=" * 80
  end

end
