shared_context "simple renderer" do

  let(:renderer_class) do
    klass = Class.new
    klass.send :include, described_class

    klass
  end

  subject do
    renderer_class.new
  end

end
