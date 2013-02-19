shared_context "default context" do

  subject do
    require "documentation/context"

    Documentation::Context.new(fixture_root, :en)
  end

end
