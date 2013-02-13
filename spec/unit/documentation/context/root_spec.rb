require "documentation/context"

describe Documentation::Context, "#root" do
  include_context "default context"

  it "should return the root document" do
    subject.root
  end

  describe "error cases" do

    subject do
      Documentation::Context.new(fixture_root, :not_a_lang)
    end

    it "should raise for unknown languages" do
      expect { subject.root }.to raise_error(Documentation::DocumentNotFoundError)
    end

  end

end
