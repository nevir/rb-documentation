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

  [:html].each do |format|
    describe "#{format} formatted output" do
      fixtures_by_lang.each do |language, fixtures|

        let(:context) do
          Documentation::Context.new(fixture_root, language)
        end

        let(:out_path) do
          result  = File.join(output_root, format.to_s, language, fixture_path)
          result += "index" if fixture_path.end_with?("/") || fixture_path == ""

          result
        end

        def save_or_compare(output, type)
          file_path = "#{out_path}.#{type}"

          if ENV["REGEN_OUTPUT"]
            FileUtils.mkpath File.dirname(file_path)
            open(file_path, "w") do |file|
              file.write(output)
            end
          else
            expect(output).to eq(open(file_path).read)
          end
        end

        fixtures.each do |fixture|
          let(:fixture_path) do
            context.fs_to_doc_path(fixture)
          end

          it "should output #{language}:#{fixture} properly" do
            doc = context.document(fixture_path)

            save_or_compare(doc.rendered_source, "html")
            save_or_compare(doc.toc_root.to_h.to_yaml, "toc")
          end
        end

      end
    end
  end

end
