require "documentation/markdown/preprocessing"

describe Documentation::Markdown::Preprocessing, ".preprocess_indentation!" do

  it "should convert all two space indents into four" do
    body = "foo\n  bar\nbarf  baff\n    aoeu"

    described_class.preprocess_indentation! body

    expect(body).to eq("foo\n    bar\nbarf  baff\n        aoeu")
  end

end
