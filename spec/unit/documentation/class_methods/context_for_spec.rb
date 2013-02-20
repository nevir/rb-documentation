require "documentation"

describe Documentation, ".context_for" do

  it "should only require a language" do
    Documentation::Context.should_receive(:new) do |root, lang, options|
      expect(root).to eq(Documentation::DOC_ROOT)
      expect(lang).to eq(:zomg)
      expect(options).to be_a(Hash)
    end

    described_class.context_for(:zomg)
  end

  it "should pass custom options" do
    Documentation::Context.should_receive(:new) do |root, lang, options|
      expect(root).to eq(Documentation::DOC_ROOT)
      expect(lang).to eq(:en)
      expect(options[:foo]).to eq(:bar)
    end

    described_class.context_for(:en, foo: :bar)
  end

end
