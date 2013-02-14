require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#headers_seen" do
  include_context "simple renderer"

  it "should lazy-create" do
    expect(subject.headers_seen).to eq(Set.new)
  end

end
