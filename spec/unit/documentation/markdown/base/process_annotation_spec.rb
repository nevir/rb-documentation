require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#process_annotation" do
  include_context "simple renderer"

  it "should strip whitespace from the body" do
    subject.should_receive(:process_unknown_annotation).with(:testing, "hi")

    subject.process_annotation(:testing, "   hi ")
  end

  [:warning, :todo].each do |block_type|
    it "should treat #{block_type} as a block annotation" do
      subject.should_receive(:process_block_annotation).with(block_type, "body")

      subject.process_annotation(block_type, "body")
    end
  end

  [:introduced, :deprecated, :parent, :aliases, :includes].each do |metadata_type|
    it "should treat #{metadata_type} as metadata" do
      subject.should_receive(:process_metadata_annotation).with(metadata_type, "guts")

      subject.process_annotation(metadata_type, "guts")
    end
  end

end
