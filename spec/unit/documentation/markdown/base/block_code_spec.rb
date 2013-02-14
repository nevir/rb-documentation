require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#block_code" do
  include_context "simple renderer"

  it "should call out to process_annotation for annotation-tagged languages" do
    subject.should_receive(:process_annotation).with(:foo, "body")
    subject.should_not_receive(:process_code_block)

    subject.block_code("body", "annotation:foo")
  end

  it "should call out to process_code_block for other languages" do
    subject.should_receive(:process_code_block).with("def foo; end", "ruby")
    subject.should_not_receive(:process_annotation)

    subject.block_code("def foo; end", "ruby")
  end

end
