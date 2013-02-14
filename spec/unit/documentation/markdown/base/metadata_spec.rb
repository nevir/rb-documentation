require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#metadata" do
  include_context "simple renderer"

  it "should lazy-create" do
    expect(subject.metadata).to eq({})
  end

end
