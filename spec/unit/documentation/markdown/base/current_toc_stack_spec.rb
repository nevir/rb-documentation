require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#current_toc_stack" do
  include_context "simple renderer"

  it "should lazy-create" do
    expect(subject.current_toc_stack).to eq([subject.toc_root])
  end

end
