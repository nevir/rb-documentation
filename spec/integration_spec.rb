require "documentation/context"
require "fileutils"

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

        fixtures.each do |fixture|
          it "should output #{language}:#{fixture} properly" do
            fixture_path = context.fs_to_doc_path(fixture)
            puts fixture_path.inspect

            out_path  = File.join(output_root, format.to_s, language, fixture_path)
            out_path += "index" if fixture_path.end_with?("/") || fixture_path == ""
            out_path += ".#{format}"

            doc = context.document(fixture_path)

            if ENV["REGEN_OUTPUT"]
              FileUtils.mkpath File.dirname(out_path)
              open(out_path, "w") do |file|
                file.write(doc.rendered_source)
              end

            else
              expect(doc.rendered_source).to eq(open(out_path).read)
            end
          end
        end

      end
    end
  end

end
