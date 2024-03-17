# frozen_string_literal: true

require_relative "lib/rgss_db/version"

Gem::Specification.new do |spec|
  spec.name = "rgss_db"
  spec.version = RgssDb::VERSION
  spec.authors = ["SnowSzn"]
  spec.email = ["fergarpaal@gmail.com"]

  spec.summary = "Manipulates the RPG Maker database in the terminal"
  spec.description = "Manipulates the RPG Maker database in the terminal"
  spec.homepage = "https://github.com/SnowSzn/rgss-db-cli"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Depedencies
  spec.add_dependency "colorize", "~> 1.1"
  spec.add_dependency "json", "~> 2.7"
  spec.add_dependency "optimist", "~> 3.1.0"
  spec.add_dependency "psych", "~> 5.1"
  spec.add_dependency "tty-box", "~> 0.7.0"
  spec.add_dependency "tty-progressbar", "~> 0.18.2"
  spec.add_dependency "tty-prompt", "~> 0.23.1"
  spec.add_dependency "tty-screen", "~> 0.8.2"
  spec.add_dependency "tty-spinner", "~> 0.9.3"
  spec.add_dependency "tty-table", "~> 0.12.0"

  # Dev dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "rubocop-performance", "~> 1.20"
  spec.add_development_dependency "rubocop-rake", "~> 0.6.0"
  spec.add_development_dependency "rubocop-rspec", "~> 2.27"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
