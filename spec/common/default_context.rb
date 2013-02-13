shared_context "default context" do

  let(:fixture_root) do
    File.expand_path("../../fixtures", __FILE__)
  end

  subject do
    require "documentation/context"

    Documentation::Context.new(fixture_root, :en)
  end

end
