require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#process_code_block" do
  include_context "simple renderer"

  it "should be an abstract method" do
    expect { subject.process_code_block(:warning, "zomg") }.to raise_error(NotImplementedError, /process_code_block/)
  end

end
