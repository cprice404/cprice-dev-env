require 'teamcity/rakerunner_consts'

RUBY19_SDK_MINITEST_RUNNER_PATH = ENV[::Rake::TeamCity::RUBY19_SDK_MINITEST_RUNNER_PATH_KEY]
if RUBY19_SDK_MINITEST_RUNNER_PATH
  require RUBY19_SDK_MINITEST_RUNNER_PATH
end

#noinspection RubyLocalVariableNamingConvention
minitest_reporters_gem_detected = false
$:.each do |path|
  unless  path["/gems/minitest-reporters"].nil?
    minitest_reporters_gem_detected = true
    break
  end
end

unless minitest_reporters_gem_detected
  module MiniTest
    class Unit
      class << self
        @@jb_runner_wrapper_applicable = MiniTest::Unit.respond_to?(:autorun, true)
        if @@jb_runner_wrapper_applicable
          alias jb_original_autorun autorun
          private :jb_original_autorun
        end

        def autorun(*args)
          jb_original_autorun(*args)
        end

        # warn user:
        product_name = ::Rake::TeamCity.is_in_buildserver_mode ? "TeamCity" : "RubyMine/IDEA Ruby plugin"
        msg = "\nMiniTest framework was detected. It is a lightweight version of original Test::Unit framework.\n#{product_name} test runner requires 'minitest-reporters' (>= 0.4.1) for integration\nwith MiniTest framework. Or you can use full-featured Test::Unit framework version, provided by\n'test-unit' gem, otherwise default console tests reporter will be used instead.\n\n"
        STDERR.flush
        STDOUT.flush
        STDERR.puts msg
        STDERR.flush
        STDOUT.flush

        unless @@jb_runner_wrapper_applicable
          STDERR.puts "Error: Cannot delegate to original 'minitest\\unit.rb' script.\n\n"
          exit(1)
        end
      end
    end
  end
end