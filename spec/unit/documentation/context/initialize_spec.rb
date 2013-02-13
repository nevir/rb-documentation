require "documentation/context"

describe Documentation::Context, "#initialize" do
  include_context "default context"

  describe "defaults" do

    it "should default to English" do
      expect(subject.lang).to eq(:en)
    end

    it "should default to the HTML renderer" do
      expect(subject.format).to eq(:html)
    end

    it "should set up the root path" do
      expect(subject.root_path).to eq(fixture_root)
    end

    it "should have sane redcarpet defaults" do
      Redcarpet::Markdown.should_receive(:new) do |renderer, options|
        expect(renderer).to be_a(Documentation::Markdown::HTML)
        expect(options).to eq(
          no_intra_emphasis:   true,
          tables:              true,
          fenced_code_blocks:  true,
          autolink:            true,
          strikethrough:       true,
          lax_spacing:         false,
          space_after_headers: true,
          superscript:         true,
        )
      end

      subject
    end

  end

  describe "format" do

    it "should coerce string format values" do
      context = Documentation::Context.new(fixture_root, :en, format: "html")
      expect(context.format).to eq(:html)
    end

    it "should raise if given an unknown format" do
      expect { Documentation::Context.new(fixture_root, :en, format: :bad_format) }.to raise_error(TypeError, /format/)
    end

  end

  describe "options" do

    it "should pass options to the renderer" do
      Documentation::Markdown::HTML.should_receive(:new) do |options|
        expect(options[:thing_to_do]).to eq(12345)
      end
      Redcarpet::Markdown.stub(:new)

      Documentation::Context.new(fixture_root, :en, thing_to_do: 12345)
    end

    it "should pass options to the redcarpet context" do
      Redcarpet::Markdown.should_receive(:new) do |renderer, options|
        expect(options[:fake_redcarpet_option]).to eq(:stuff)
      end

      Documentation::Context.new(fixture_root, :en, fake_redcarpet_option: :stuff)
    end

  end

end
