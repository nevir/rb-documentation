require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#toc_root" do
  include_context "simple renderer"

  it "should lazy-create" do
    expect(subject.toc_root).to be_a(Documentation::Markdown::HeaderNode)

    expect(subject.toc_root.title).to    eq(nil)
    expect(subject.toc_root.slug).to     eq(nil)
    expect(subject.toc_root.level).to    eq(0)
    expect(subject.toc_root.children).to eq([])
  end

end
