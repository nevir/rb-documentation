require "documentation/context"

describe Documentation::Context, "#document" do
  include_context "default context"

  it "should return a well formed Document" do
    doc = subject.document("")

    expect(doc).to be_a(Documentation::Document)
    expect(doc.rendered_source).to include("Chaos")
    expect(doc.rendered_source).to_not include("=====")

    expect(doc.toc_root).to be_a(Documentation::Markdown::HeaderNode)
  end

  it "should preprocess the document body" do
    Documentation::Markdown::Preprocessing.should_receive(:preprocess!)

    subject.document("")
  end

  it "should reset the renderer" do
    Documentation::Markdown::HTML.any_instance.should_receive(:reset_for_reuse!).and_call_original

    subject.document("")
  end

  describe "error cases" do

    it "should raise for unknown files" do
      expect { subject.document("missing/stuff") }.to raise_error(Documentation::DocumentNotFoundError)
    end

  end

end
