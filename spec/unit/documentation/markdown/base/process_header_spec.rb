require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#process_header" do
  include_context "simple renderer"

  it "should be an abstract method" do
    expect { subject.process_header("stuff", "foo", 1) }.to raise_error(NotImplementedError, /process_header/)
  end

end
