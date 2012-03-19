# Copyright 2000-2009 JetBrains s.r.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# @author: Roman Chernyatchik

#########################################
# Settings
#########################################
require File.dirname(__FILE__) + '/runner_settings'
require 'teamcity/utils/runner_utils'


def collect_test_scripts()
  test_scripts = []
  Dir["#{IntelliJ::FOLDER_PATH}/#{IntelliJ::SEARCH_MASK}"].each { |file|
    next if File.directory?(file)

    # else just collect tests and run them using Drb
    test_scripts << file
  }
  test_scripts
end

def load_scripts_to_object_space(test_scripts)
  puts "Loading files.... "
  puts SEPARATOR

  i = 1
  test_scripts.each do |test_script|
    begin
      # Changes directory before require, because previous required script can change it
      Dir.chdir(IntelliJ::WORK_DIR) if IntelliJ::WORK_DIR


      # if no DRB - load scripts to ObjectSpace and run in the same process
      # such way will support debugging out of the box
      require test_script

      puts "#{i}. #{test_script}:1"
      i += 1;
    rescue Exception => e
      puts "Fail to load: #{test_script}:1\n      Exception message: #{e}\n        #{e.backtrace.join("\n        ")}"
    end
  end
  puts " \n"
  puts "#{i-1} files were loaded."
end

def launch_tests_using_drb(drb_runner, test_scripts)
  cmdline = []

  IntelliJ::parse_launcher_string(IntelliJ::RUBY_INTERPRETER_CMDLINE, cmdline)

  # drb runner
  cmdline << drb_runner

  # tests to launch
  cmdline.concat(test_scripts)

  require 'rubygems'
  require 'rake'
  puts sh(*cmdline)
end

def is_test_case_class?(obj)
  begin
    is_test_case = (obj.kind_of?(Class) == true) && obj.ancestors.include?(Test::Unit::TestCase) && (obj != Test::Unit::TestCase)
  rescue Exception => e
    is_test_case = false
  end
  is_test_case
end

#########################################
# Runner
#########################################
SEPARATOR = "========================================="

# If work directory was specified
puts "Work directory: #{IntelliJ::WORK_DIR}}" if IntelliJ::WORK_DIR

# Drb
drb_runner = IntelliJ::TUNIT_DRB_RUNNER_PATH


test_scripts = collect_test_scripts()
if (drb_runner.nil?)
  load_scripts_to_object_space(test_scripts)
else
  puts " \n"
  puts "#{test_scripts.length} test scripts were detected:"
  puts SEPARATOR

  test_scripts.each_with_index do |test_script, i|
     puts "#{i+1}. #{test_script}:1"
  end
end

puts SEPARATOR

unless drb_runner.nil?
  # Parses launch arguments - ruby interpreter and its arguments
  launch_tests_using_drb(drb_runner, test_scripts)
else
  # Searches suites
  puts "Searching test suites..."

  require 'test/unit'

  ::Rake::TeamCity::RunnerUtils.ignore_root_test_case = false

  elapsed_time = 0
  test_count = 0
  assertion_count = 0
  failure_count = 0
  error_count = 0

  i = 1
  ObjectSpace.each_object do |obj|
    unless is_test_case_class?(obj)
      next
    end

    require IntelliJ::TEST_UNIT_RUNNER_PATH if i == 1

    # print testcase name
    puts SEPARATOR
    puts "Test suite \##{i}: #{obj}"
    puts "  \n"

    if ::Rake::TeamCity::RunnerUtils.excluded_default_testcase_name?(obj.name)
      puts "Ignored because it is default rails empty test suite"
    else
      # process test suite
      i+=1

      begin_time = Time.now
      result = IntelliJ::get_test_unit_runner_class.run(obj)
      elapsed_time += Time.now - begin_time
      test_count += result.run_count
      assertion_count += result.assertion_count
      error_count += result.error_count
      failure_count += result.failure_count
    end
  end
  puts SEPARATOR
  puts "#{i-1} test suites, #{test_count} tests, #{assertion_count} assertions, #{failure_count} failures, #{error_count} errors"
  puts "Finished in #{elapsed_time} seconds." if IntelliJ::USE_CONSOLE_RUNNER

  at_exit do
    Test::Unit.run = true;
  end
end