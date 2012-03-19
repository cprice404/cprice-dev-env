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

# Created by IntelliJ IDEA.
#
# @author: Roman.Chernyatchik
# @date: 02.06.2007

require 'teamcity/utils/logger_util'

UNIT_TESTS_RUNNER_LOG = Rake::TeamCity::Utils::TestUnitFileLogger.new
UNIT_TESTS_RUNNER_LOG.log_msg("testrunner.rb loaded.")

require 'test/unit/ui/testrunnermediator'
require 'test/unit/ui/testrunnerutilities'
require 'test/unit/ui/teamcity/testrunner_events'

# Runs a Test::Unit::TestSuite on teamcity server.
class Test::Unit::UI::TeamCity::TestRunner
  extend Test::Unit::UI::TestRunnerUtilities

  # Includes module with event handlers
  include Test::Unit::UI::TeamCity::EventHandlers

  def patch_suite_if_single_test()
    test_method_name = ::Rake::TeamCity.test_unit_method_name
    if test_method_name
      # run single method
      # let's filter suites
      puts "Running single test : #{test_method_name}"
      if @root_suite.respond_to?(:tests)
        # Here we suggest that top level suite
        # is for whole file and contains child suites
        # for each test class
        class_suites = @root_suite.tests
        unmatched_tests = []
        class_suites.each do |class_suite|
          next unless class_suite.respond_to?(:tests)
          # let's iterate tests methods in class
          class_tests = class_suite.tests
          class_tests.each do |test_method|
            each_test_name = test_method.method_name.strip
            # letch check whether test_method matches with
            # our filter
            if test_method_name != each_test_name
              unmatched_tests << test_method
            end
          end
          unmatched_tests.each do |t|
            class_tests.delete(t)
          end
          unmatched_tests.clear
        end
      end
    end
  end

  # Creates a new TestRunner for running the passed
  # suite.
  def initialize(suite, output_level=NORMAL)

    if (suite.respond_to?(:suite))
      @root_suite = suite.suite
    else
      @root_suite = suite
    end

    # if we are in single test mode
    # we should remove all tests from suites
    # except marked suite
    patch_suite_if_single_test()

    @result = nil
  end


  # Starts testing
  def start
    setup_mediator
    attach_to_mediator

    # Saves STDOUT, STDERR because bugs in testrunner can break it.
    sout, serr = copy_stdout_stderr
    begin
      start_mediator
    ensure
      # Repairs stdout and stderr just in case
      sout.flush
      serr.flush
      reopen_stdout_stderr(sout, serr)
    end

    @result
  end

  def start_mediator
    @mediator.run_suite
  end

  private

  def setup_mediator
    set_message_factory(Rake::TeamCity::MessageFactory)
    @mediator = Test::Unit::UI::TestRunnerMediator.new(@root_suite)
    @root_suite_name = (@root_suite.kind_of?(Module) ? @root_suite.name : @root_suite.to_s)
  end

  def attach_to_mediator
    @mediator.add_listener(Test::Unit::TestResult::FAULT, &method(:add_fault))
    @mediator.add_listener(Test::Unit::TestResult::CHANGED, &method(:result_changed))

    @mediator.add_listener(Test::Unit::TestCase::STARTED, &method(:test_started))
    @mediator.add_listener(Test::Unit::TestCase::FINISHED, &method(:test_finished))

    @mediator.add_listener(Test::Unit::TestSuite::STARTED, &method(:suite_started))
    @mediator.add_listener(Test::Unit::TestSuite::FINISHED, &method(:suite_finished))

    @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::STARTED, &method(:started))
    @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::FINISHED, &method(:finished))
    @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::TC_TESTCOUNT, &method(:reset_ui))
    @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::TC_REPORTER_ATTACHED, &method(:log_test_reporter_attached))
    #@mediator.add_listener(Test::Unit::UI::TestRunnerMediator::RESET, &method(:reset_ui))
  end
end

if __FILE__ == $0
  Test::Unit::UI::TeamCity::TestRunner.start_command_line_test
end

at_exit do
  UNIT_TESTS_RUNNER_LOG.log_msg("testrunner.rb: Finished")
  UNIT_TESTS_RUNNER_LOG.close
end