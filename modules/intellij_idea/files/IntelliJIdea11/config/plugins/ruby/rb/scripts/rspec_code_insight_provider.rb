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

require 'code_insight/code_insight_helper'

#TODO RPSEC 2.0

def register_double_creators_methods()
  # add stub, mock, don't allow using verification strategy,
  # see: rr-0.10.0/lib/rr/double_definitions/strategies/verification/[stub.rb, mock.rb, dont_allow.rb]
  set_dynamic_methods :methods => [:stub, :stub!]
  #:class_to_resolve => "RR::DoubleDefinitions::Strategies::Verification::Stub"
  set_dynamic_methods :methods => [:mock, :mock!]
  #:class_to_resolve => "RR::DoubleDefinitions::Strategies::Verification::Mock"
  set_dynamic_methods :methods => [:dont_allow, :do_not_allow, :dont_call, :do_not_call]
  #:class_to_resolve => "RR::DoubleDefinitions::Strategies::Verification::DontAllow"
end

def register_dynamic_methods()
  # matchers
  describe "Spec::Matchers" do
    be_matchers = %w(be_true be_false be_nil be_arbitrary_predicate)
    be_matchers.each do |method_name|
      set_dynamic_methods :methods => method_name,
                          :method_to_resolve => "Spec::Matchers.be"
    end

  end

  # RR mocking
  describe 'RR::Adapters::RRMethods' do
    register_double_creators_methods()
  end

  describe 'RR::DoubleDefinitions::DoubleDefinitionCreator' do
    register_double_creators_methods()
  end

  describe 'RR::DoubleDefinitions::DoubleDefinitionCreatorProxy' do
    set_dynamic_class_type :type => "RR::DoubleDefinitions::DoubleDefinition"
  end
end

def register_return_types_for_double_creators()
  [:stub, :stub!, :mock, :mock!, :dont_allow, :do_not_allow, :dont_call, :do_not_call].each do |name|
    set_return_type name => or_type("RR::DoubleDefinitions::DoubleDefinitionCreator",
                                    or_type("RR::DoubleDefinitions::DoubleDefinition",
                                            "RR::DoubleDefinitions::DoubleDefinitionCreatorProxy"))
  end
end

def register_dynamic_types()
  # RSpec bundled mocking framework
  describe 'Spec::Mocks::Methods' do
    set_return_type "should_receive" => "Spec::Mocks::MessageExpectation"
    set_return_type "should_not_receive" => "Spec::Mocks::MessageExpectation"
    set_return_type "stub!" => "Spec::Mocks::MessageExpectation"
    set_return_type "unstub!" => "Spec::Mocks::MessageExpectation"
    set_return_type "stub_chain" => "Spec::Mocks::MessageExpectation"
    set_return_type "received_message?" => "Boolean"
    set_return_type "null_object?" => "Boolean"
  end

  # RR Mocks
  describe 'RR::Adapters::RRMethods' do
    register_return_types_for_double_creators()
  end

  describe 'RR::DoubleDefinitions::DoubleDefinitionCreator' do
    register_return_types_for_double_creators()
  end
end

###########################################################################
# dynamically defined methods registration
###########################################################################
register_dynamic_methods()

###########################################################################
# implicit types association
###########################################################################
register_dynamic_types()