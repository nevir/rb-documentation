require "documentation/markdown/preprocessing"

describe Documentation::Markdown::Preprocessing, ".preprocess_annotations!" do

  it "should convert single-line annotations into a code block" do
    body = "FOO: 1, 2, 3"

    described_class.preprocess_annotations! body

    expect(body).to eq("```annotation:foo\n1, 2, 3\n```\n")
  end

  it "should convert indented multi-line annotations into a code block" do
    body = "BAR:\n  asdf\n  aoeu"

    described_class.preprocess_annotations! body

    expect(body).to eq("```annotation:bar\nasdf\naoeu\n```\n")
  end

  it "should stop indented multi-line annotations once indentation finishes" do
    body = "BARF:\n  asdf\n\n  aoeu\n\nhmm."

    described_class.preprocess_annotations! body

    expect(body).to eq("```annotation:barf\nasdf\n\naoeu\n```\n\nhmm.")
  end

  it "should handle  multi-line annotations with varying indentation" do
    body = "BARF:\n  asdf\n\n    aoeu\n  foo\n"

    described_class.preprocess_annotations! body

    expect(body).to eq("```annotation:barf\nasdf\n\n  aoeu\nfoo\n```\n\n")
  end

  it "should ignore mixed case labels" do
    body = "foo:\n  asdf\n  aoeu"

    described_class.preprocess_annotations! body

    expect(body).to eq("foo:\n  asdf\n  aoeu")
  end

end
