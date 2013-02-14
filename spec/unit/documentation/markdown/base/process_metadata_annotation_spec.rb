require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#process_metadata_annotation" do
  include_context "simple renderer"

  before(:each) do
    subject.stub(:warn)
  end

  it "should store metadata" do
    subject.should_not_receive(:warn)
    subject.process_metadata_annotation(:parent, "hi")

    expect(subject.metadata[:parent]).to eq("hi")
  end

  it "should not generate any content" do
    subject.should_not_receive(:warn)
    result = subject.process_metadata_annotation(:parent, "hi")

    expect(result).to eq("")
  end

  it "should warn about duplicate sets" do
    subject.process_metadata_annotation(:aliases, "foo, bar")

    subject.should_receive(:warn) do |message|
      expect(message).to include("annotation")
      expect(message).to include("aliases")
      expect(message).to include("foo, bar")
      expect(message).to include("baz")
    end

    subject.process_metadata_annotation(:aliases, "baz")
  end

end
