#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |task|
  # No special configuration yet.
end

desc "Run the full test suite"
task :default => [:spec, :mutate]

desc "Run the tests in CI mode"
task :ci => [:spec, :mutate]

desc "Boot up an IRB console w/ documentation preloaded"
task :console do
  require "documentation"
  require "irb"

  # IRB parses ARGV on start; let's make it think that its in its own environment
  ARGV.clear
  IRB.start
end

desc "Runs tests with code mutation"
task :mutate do
  # Skip if we're in JRuby or Ruby 2.0 (mutant doesn't support 'em)
  unless RUBY_VERSION.start_with?("2.") || RUBY_PLATFORM.include?("java")
    require "documentation"
    require "mutant"

    config = {}
    def config.method_missing(sym)
      self[sym]
    end

    # mutate anything that has a unit test folder
    unit_folders   = Dir["spec/unit/**/*/"].map { |f| f[/^spec.unit.(.+)./, 1] }
    unit_constants = unit_folders.map do |folder|
      folder.gsub(File::SEPARATOR, "::").gsub("_", "").downcase
    end

    config.merge!(
      strategy: Mutant::Strategy::Rspec::DM2.new(config),
      killer:   Mutant::Killer::Rspec,
      matcher:  Mutant::Matcher::ObjectSpace.new(/\A(#{unit_constants.join("|")})\Z/i),
      filter:   Mutant::Mutation::Filter::ALL,
      reporter: Mutant::Reporter::CLI.new(config),
    )

    task_index = ARGV.index("mutate")
    if task_index && matcher = ARGV[task_index + 1]
      config[:matcher] = Mutant::Matcher.from_string("::Documentation::#{matcher}")
    end

    ENV["MUTATION"] = "yes"
    exit Mutant::Runner.run(config).fail? ? 1 : 0
  end
end

namespace :integration do
  # See [the ;spec docs](spec/).
  desc "Regenerate integration output"
  task :regen do
    require "fileutils"

    # untracked files are ok
    mods = `git status --porcelain`.lines.reject { |s| s.start_with? "??" }
    if mods.size > 0
      $stdout.puts "Refusing to regen integration output until your working copy is clean."
      exit 1
    end

    ENV["REGEN_OUTPUT"] = "yes"
    # Fresh start
    FileUtils.rmtree File.expand_path("../spec/integration", __FILE__)

    system "bundle exec rspec spec/integration_spec.rb"

    exit $?.exitstatus unless $?.success?

    # diff changes to existing files
    system "git add --patch spec/integration"
    # add any new files
    system "git add spec/integration"
  end
end
