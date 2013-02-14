require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#slug_for_header_text" do
  include_context "simple renderer"

  it "should strip HTML from the text" do
    expect(subject.slug_for_header_text("<b>hi</b>")).to eq("hi")
  end

  it "should downcase all tokens" do
    expect(subject.slug_for_header_text("UPPERer")).to eq("upperer")
  end

  it "should split CamelCaps" do
    expect(subject.slug_for_header_text("SomeClass")).to eq("some-class")
  end

  it "should split camelCase" do
    expect(subject.slug_for_header_text("someThing")).to eq("some-thing")
  end

  it "should ensure a unique slug for duplicate text" do
    subject.slug_for_header_text("repeat")
    expect(subject.slug_for_header_text("repeat")).to eq("repeat-2")
    expect(subject.slug_for_header_text("repeat")).to eq("repeat-3")
  end

end
