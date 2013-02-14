require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#process_unknown_annotation" do
  include_context "simple renderer"

  before(:each) do
    subject.stub(:warn)
  end

  it "should not generate any content" do
    result = subject.process_unknown_annotation(:asdf, "hi")

    expect(result).to eq("")
  end

  it "should warn" do
    subject.should_receive(:warn) do |message|
      expect(message).to include("unknown_type")
      expect(message).to include("stuff")
    end

    subject.process_unknown_annotation(:unknown_type, "stuff")
  end

end
