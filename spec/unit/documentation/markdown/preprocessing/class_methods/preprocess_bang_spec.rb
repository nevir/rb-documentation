require "documentation/markdown/preprocessing"

describe Documentation::Markdown::Preprocessing, ".preprocess!" do

  it "should call into the individual preprocessors" do
    described_class.should_receive(:preprocess_indentation!).with("foo")
    described_class.should_receive(:preprocess_annotations!).with("foo")

    described_class.preprocess! "foo"
  end

end
