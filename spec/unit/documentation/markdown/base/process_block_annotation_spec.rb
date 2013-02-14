require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#process_block_annotation" do
  include_context "simple renderer"

  it "should be an abstract method" do
    expect { subject.process_block_annotation("asdf", :en) }.to raise_error(NotImplementedError, /process_block_annotation/)
  end

end
