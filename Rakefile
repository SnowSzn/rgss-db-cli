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
  # Executables info variables
  executable_names = %w[rgss-db rgssdb]
  executable_content = <<~EOF
    #!/usr/bin/env ruby
    # frozen_string_literal: true

    require_relative "../lib/rgss_db"
  EOF

  # Create executables
  exe_dir = File.join(File.dirname(__FILE__), "bin")

  mkdir_p exe_dir unless File.directory?(exe_dir)

  executable_names.each do |exe_name|
    exe_path = File.join(exe_dir, exe_name)

    File.open(exe_path, "w") do |file|
      file.puts(executable_content)
    end

    chmod(0o755, exe_path)
  end
end

desc "Generates rbs docs with sord"
task :sord do
  rbs_dir = File.join(File.dirname(__FILE__), "./sig/")
  rbs_path = File.join(rbs_dir, "rgss_db.rbs")

  mkdir_p rbs_dir unless File.directory?(rbs_dir)

  sh "sord '#{rbs_path}' --rbs"
end

task default: :rubocop
