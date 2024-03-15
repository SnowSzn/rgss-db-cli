# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rake"
require "rake/clean"

RuboCop::RakeTask.new do |task|
  task.requires << "rubocop-performance"
  task.requires << "rubocop-rspec"
  task.requires << "rubocop-rake"
end

desc "Build app executable inside the bin directory"
task :build_exe do
  executable_name = "rgss-db"
  executable_content = <<~EOF
    #!/usr/bin/env ruby
    # frozen_string_literal: true

    require_relative "../lib/rgss_db"
  EOF

  bin_dir = File.join(File.dirname(__FILE__), "bin")

  mkdir_p bin_dir unless File.exist?(bin_dir)

  executable_path = File.join(bin_dir, executable_name)

  File.open(executable_path, "w") do |file|
    file.puts(executable_content)
  end

  chmod(0o755, executable_path)
end

task default: :rubocop
