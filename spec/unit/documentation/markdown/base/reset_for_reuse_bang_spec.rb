require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#reset_for_reuse!" do
  include_context "simple renderer"

  it "should clear the renderer's state" do
    subject.instance_eval do
      @metadata     = {stuff: 123, flag: "foo"}
      @headers_seen = Set.new([1, 2, 3])
      @toc_root     = :boom

      @current_toc_stack = [:boom]
    end

    subject.reset_for_reuse!

    expect(subject.metadata).to          eq({})
    expect(subject.headers_seen).to      eq(Set.new)

    expect(subject.toc_root).to be_a(Documentation::Markdown::HeaderNode)
    expect(subject.toc_root.title).to    eq(nil)
    expect(subject.toc_root.slug).to     eq(nil)
    expect(subject.toc_root.level).to    eq(0)
    expect(subject.toc_root.children).to eq([])

    expect(subject.current_toc_stack).to eq([subject.toc_root])
  end

end
