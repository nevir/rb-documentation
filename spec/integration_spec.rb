require "documentation/context"
require "fileutils"
require "yaml"

# This is a mess!
describe "All Together Now" do
  fixture_root = File.expand_path("../fixtures", __FILE__)
  output_root  = File.expand_path("../integration", __FILE__)

  fixtures_by_lang = Hash.new { |h,k| h[k] = [] }
  Dir["#{fixture_root}/**/*.md"].map { |path|
    lang, fixture = path[(fixture_root.size + 1)..-1].split(File::SEPARATOR, 2)

    fixtures_by_lang[lang].push fixture
  }

  def save_or_compare(output_path, type, output)
    file_path = "#{output_path}.#{type}"

    if ENV["REGEN_OUTPUT"]
      FileUtils.mkpath File.dirname(file_path)
      open(file_path, "w") do |file|
        file.write(output)
      end
    else
      expect(output).to eq(open(file_path).read)
    end
  end

  fixtures_by_lang.each do |language, fixtures|
    context = Documentation::Context.new(fixture_root, language)

    fixtures.each do |fixture|
      describe "#{language}:#{fixture}" do
        let(:fixture_path) { context.fs_to_doc_path(fixture) }
        let(:doc)          { context.document(fixture_path) }
        let(:output_path) do
          result  = File.join(output_root, language, fixture_path)
          result += "index" if fixture_path.end_with?("/") || fixture_path == ""
          result
        end

        [:html].each do |format|
          it "should render properly as #{format}" do
            save_or_compare(output_path, format.to_s, doc.rendered_source)
          end
        end

        it "should extract the full table of contents" do
          save_or_compare(output_path, "toc", doc.toc_root.to_h.to_yaml)
        end

        it "should extract the document metadata" do
          save_or_compare(output_path, "meta", doc.metadata.to_yaml)
        end
      end
    end
  end

end
