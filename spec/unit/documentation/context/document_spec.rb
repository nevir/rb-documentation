require "documentation/context"

describe Documentation::Context, "#document" do
  include_context "default context"

  it "should return a well formed Document" do
    doc = subject.document("README.md")

    expect(doc).to be_a(Documentation::Document)
    expect(doc.rendered_source).to include("English Fixture")
    expect(doc.toc_root).to be_a(Documentation::Markdown::HeaderNode)
  end

  it "should preprocess the document body" do
    Documentation::Markdown::Preprocessing.should_receive(:preprocess!)

    subject.document("README.md")
  end

  it "should reset the renderer" do
    Documentation::Markdown::HTML.any_instance.should_receive(:setup!).and_call_original

    subject.document("README.md")
  end

  describe "error cases" do

    it "should raise for unknown files" do
      expect { subject.document("missing/stuff.md") }.to raise_error(Documentation::DocumentNotFoundError)
    end

  end

end
