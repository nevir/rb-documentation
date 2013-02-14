require "rubygems"

begin
  require "spork"
  require "spork/ext/ruby-debug"
rescue LoadError
  # No spork? No problem!
  module Spork
    def self.prefork
      yield
    end

    def self.each_run
      yield
    end
  end
end

Spork.prefork do
  # Allow requires relative to the spec dir
  SPEC_ROOT = File.expand_path("..", __FILE__)
  $LOAD_PATH << SPEC_ROOT

  require "time"
  require "rspec"

  # Load our spec environment (random to avoid dependency ordering)
  Dir[File.join(SPEC_ROOT, "common", "*.rb")].shuffle.each do |helper|
    require "common/#{File.basename(helper, ".rb")}"
  end

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true

    # Time out (particularly useful for mutant)
    config.around(:each) do |spec|
      # We can't use `timeout` until > rspec 2.12.2 for commit:
      # https://github.com/rspec/rspec-core/commit/56078dad21f7c1d55dcfb54045ff34423acc8873#lib/rspec/core/formatters/base_text_formatter.rb
      worker = Thread.new do
        spec.run
      end
      worker.join(0.5)

      if worker.alive?
        worker.kill
        raise "Spec timed out"
      end
    end

    # Be verbose about warnings
    config.around(:each) do |spec|
      old_verbose = $VERBOSE
      # Or not at all if we are in mutation testing
      $VERBOSE = ENV["MUTATION"] ? nil : 2

      spec.run

      $VERBOSE = old_verbose
    end
  end
end
