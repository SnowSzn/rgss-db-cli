# frozen_string_literal: true

require_relative "lib/rgss_db/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 3.0.0"
  spec.name = "rgss_db"
  spec.version = RgssDb::VERSION
  spec.authors = ["SnowSzn"]
  spec.email = ["fergarpaal@gmail.com"]

  spec.summary = "Manipulates the RPG Maker database to export and import RPG Maker data"
  spec.description = <<~EOF
    rgss_db is a tool designed for developers to export and import the database files of a game created in RPG Maker.

    This gem is compatible with any RPG Maker editor based on RGSS, including:
      - RPG Maker XP
      - RPG Maker VX
      - RPG Maker VX Ace

    The gem provides a CLI to easily interact with the RPG Maker database.

    You can avoid this interface by providing an action to perform.

    Please check the repository at github for more information!

    https://github.com/SnowSzn/rgss-db-cli
  EOF
  spec.homepage = "https://github.com/SnowSzn/rgss-db-cli"
  spec.license = "GPL-3.0-only"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "https://github.com/SnowSzn/rgss-db-cli/issues"
  spec.metadata["changelog_uri"] = "https://github.com/SnowSzn/rgss-db-cli/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    Dir.glob(
      ["lib/**/*", "bin/**/*", "sig/**/*"]
    ).push("CHANGELOG.md", "README.md", "COPYING.md")
  end
  spec.require_paths = ["lib"]
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }

  # Depedencies
  spec.add_dependency "colorize", "~> 1.1"
  spec.add_dependency "fileutils", "~> 1.7"
  spec.add_dependency "json", "~> 2.7"
  spec.add_dependency "optimist", "~> 3.2"
  spec.add_dependency "psych", "~> 5.1"
  spec.add_dependency "tty-box", "~> 0.7.0"
  spec.add_dependency "tty-prompt", "~> 0.23.1"
  spec.add_dependency "tty-spinner", "~> 0.9.3"
  spec.add_dependency "tty-table", "~> 0.12.0"

  # Dev dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.74"
  spec.add_development_dependency "rubocop-performance", "~> 1.24"
  spec.add_development_dependency "rubocop-rake", "~> 0.7"
  spec.add_development_dependency "rubocop-rspec", "~> 3.5"
  spec.add_development_dependency "sord", "~> 7.0"
  spec.add_development_dependency "yard", "~> 0.9"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
