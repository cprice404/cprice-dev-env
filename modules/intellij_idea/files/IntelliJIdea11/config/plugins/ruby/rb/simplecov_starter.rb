require 'rubygems'
require 'simplecov'

SimpleCov.at_exit do
  # getting result will trigger ResultMerger to store results
  # if merging is not disabled
  SimpleCov.result 
end

# trick SimpleCov::ResultMerger into using provided output file
module SimpleCov::ResultMerger
  def self.resultset_path
    ENV['RUBYMINE_SIMPLECOV_COVERAGE_PATH']
  end
end

SimpleCov.project_name ENV['RUBYMINE_SIMPLECOV_RUN_CONFIGURATION'] 
SimpleCov.use_merging ENV['RUBYMINE_SIMPLECOV_MERGING'] != 'false'

env = ""
i = 1
while env do
  env = ENV["RUBYMINE_SIMPLECOV_EXCLUDE_#{i}"]
  if env
    if pattern[0] == "/" && pattern[-1] == "/"
      SimpleCov.add_filter pattern[1..-2]
    else
      SimpleCov.add_filter pattern
    end
  end
  i += 1
end

SimpleCov.start