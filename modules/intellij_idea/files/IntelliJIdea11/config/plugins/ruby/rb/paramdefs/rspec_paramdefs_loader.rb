#
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
#

include Java

require File.dirname(__FILE__) + '/paramdefs_loader_base'
require File.dirname(__FILE__) + '/rails/paramdefs_helper'

class RSpecParamDefsLoader < BaseParamDefsLoader
  import org.jetbrains.plugins.ruby.ruby.codeInsight.paramDefs.ParamDefProvider unless defined? ParamDefProvider

  include RailsParamDefsHelper
  include ParamDefProvider

  def registerParamDefs(manager)
    @manager = manager

    # define/context
    # rspec 2.0
    paramdef 'RSpec::Core::ObjectExtensions', ['describe', 'context'],
             nil,
             {:type => maybe_one_of(:controller, :helper, :integration, :model, :view, :routing),
              :scope => nil,
              :location => nil
             }
    define_params_copy 'RSpec::Core::ExampleGroup.describe', 'RSpec::Core::ObjectExtensions.describe'
    define_params_copy 'RSpec::Core::ExampleGroup.context', 'RSpec::Core::ObjectExtensions.describe'
    # rspec 1.x
    define_params_copy 'Spec::DSL::Main.describe', 'RSpec::Core::ObjectExtensions.describe'
    define_params_copy 'Spec::DSL::Main.context', 'Spec::DSL::Main.describe'
    define_params_copy 'Spec::Example::ExampleGroupMethods.describe', 'Spec::DSL::Main.describe'
    define_params_copy 'Spec::Example::ExampleGroupMethods.context', 'Spec::DSL::Main.describe'

    #before/after
    # rspec 2.x
    paramdef 'RSpec::Core::Hooks', ['before', 'after'],
             maybe(one_of(:each, :all, :suite))
    # rspec 1.x
    paramdef 'Spec::Example::BeforeAndAfterHooks', ['before', 'append_before', 'after', 'prepend_after'],
             maybe(one_of(:each, :all, :suite))

    # routing
    # rspec 2.x (branch with 1.x before extending this paramdef)
    paramdef 'RSpec::Matchers', "route_to",
             #TODO named root params
             {
               :action => action_ref(:class => :controller),
               :controller => controller_ref,
             }
    # rspec 1.x
    define_params_copy 'Spec::Rails::Example::RoutingHelpers.route_for', 'RSpec::Matchers.route_to'


    # method available only in rspec 1.x
    paramdef 'Spec::Rails::Example::RoutingHelpers', "params_from",
             link_to_methods,
             nil

    # controllers
    # TODO: RSpec 2.0 support
    paramdef 'Spec::Rails::Example::ControllerExampleGroup', "controller_name",
             controller_ref

    # helpers
    # TODO: RSpec 2.0 support
    paramdef 'Spec::Rails::Example::HelperExampleGroup', "helper_name",
             helper_ref(true)


    # TODO
    # mocks : rspec
    #paramdef 'Spec::Rails::Mocks', "stub_model",
    #         model_name_ref,
    #         model_fields_hash(:model_ref => 0)

  end
end
