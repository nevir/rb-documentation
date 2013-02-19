require "rspec/core/shared_context"

module GlobalSpecHelpers
  extend RSpec::Core::SharedContext

  let(:fixture_root) do
    File.expand_path("../../fixtures", __FILE__)
  end

end

RSpec.configure do |config|
  config.include GlobalSpecHelpers
end
