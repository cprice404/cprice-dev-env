include Java

require File.dirname(__FILE__) + '/paramdef_base.rb'

require File.dirname(__FILE__) + '/view_ref_param'
require File.dirname(__FILE__) + '/partial_ref_param'
require File.dirname(__FILE__) + '/controller_ref_param'
require File.dirname(__FILE__) + '/controller_method_ref_param'
require File.dirname(__FILE__) + '/action_ref_param'
require File.dirname(__FILE__) + '/action_with_children_ref_param'
require File.dirname(__FILE__) + '/method_ref_param'
require File.dirname(__FILE__) + '/model_ref_param'
require File.dirname(__FILE__) + '/attribute_ref_param'
require File.dirname(__FILE__) + '/model_name_ref_param'
require File.dirname(__FILE__) + '/association_ref_param'
require File.dirname(__FILE__) + '/used_association_ref_param'
require File.dirname(__FILE__) + '/asset_ref_param'
require File.dirname(__FILE__) + '/script_ref_param'
require File.dirname(__FILE__) + '/helper_ref_param'
require File.dirname(__FILE__) + '/migration_field_ref_param'
require File.dirname(__FILE__) + '/inverse_of_ref_param'
require File.dirname(__FILE__) + '/join_field_ref_param'
require File.dirname(__FILE__) + '/url_ref_param'
require File.dirname(__FILE__) + '/table_name_ref_param'
require File.dirname(__FILE__) + '/render_ref_param'
require File.dirname(__FILE__) + '/file_ref_param'
require File.dirname(__FILE__) + '/status_code_ref_param'
require File.dirname(__FILE__) + '/exclude_rsymbols_filter_ref_param'

require File.dirname(__FILE__) + '/action_keys_provider'

module RailsParamDefsHelper
  import org.jetbrains.plugins.ruby.ruby.lang.psi.controlStructures.methods.Visibility unless defined? Visibility
  import org.jetbrains.plugins.ruby.ruby.codeInsight.paramDefs.ResolvingParamDependency unless defined? ResolvingParamDependency
  import org.jetbrains.plugins.ruby.ruby.codeInsight.paramDefs.ArgumentValueParamDependency unless defined? ArgumentValueParamDependency

  include ParamDefs

  def action_ref(options = {})
    ActionMethodRefParam.new((options.has_key? :class) ? ResolvingParamDependency.new(':' + options[:class].to_s) : nil)
  end

  def action_with_children_ref(options = {})
    ActionWithChildrenRefParam.new((options.has_key? :class) ? ResolvingParamDependency.new(':' + options[:class].to_s) : nil)
  end

  def association_ref
    AssociationRefParam.new
  end

  # Options:
  #   :use_rails_actions_warning - tell that "action" not found instead of "method not found"
  def controller_public_method_ref(options = {})
      ControllerMethodRefParam.new(Visibility::PUBLIC, options)
  end

  def controller_ref(lookup_item_type=LookupItemType::String)
      ControllerRefParam.new lookup_item_type
  end

  def helper_ref(include_only_real_files = false)
      HelperRefParam.new(include_only_real_files)
  end

  def layout_ref
      LayoutRefParam.new
  end

  def image_ref
      AssetRefParam.new(:getImagesRootURL, "inspection.paramdef.image.warning", "images",false)
  end

  def inverse_assoc_ref(options = {})
    if (options.has_key?(:model_ref))
      InverseOfRefParam.new
    else
      nil
    end
  end

  def link_to_methods
    one_of_strings_or_symbols(:get, :post, :put, :delete, :head)
  end

  def method_ref(top_parent=nil, min_access=Visibility::PRIVATE)
      MethodRefParam.new top_parent, min_access, LookupItemType::Symbol
  end

  def migration_ref(options = {})
    model_ref, table_name = *(if options.has_key?(:model_ref)
      [ResolvingParamDependency.new(options[:model_ref].to_i), nil]
    elsif options.has_key?(:table_name)
      [nil, ArgumentValueParamDependency.new(options[:table_name].to_i)]
    else
      [nil, nil]
    end)
    MigrationFieldRefParam.new(model_ref, table_name)
  end

  def join_field_ref(options = {})
    JoinFieldRefParam.new(options.has_key?(:model_ref) ? ResolvingParamDependency.new(options[:model_ref].to_i) : nil)
  end

  def model_ref
    ModelRefParam.new
  end

  def exclude_rsymbols_filter (paramdef_ref, custom_inspection_msg = nil)
    ExcludeRSymbolsFilter.new(paramdef_ref, custom_inspection_msg)
  end

  def model_name_ref
      ModelNameRefParam.new
  end

  def model_method_ref
    method_ref('ActiveRecord::Base')
  end

  def attribute_ref
    AttributeRefParam.new
  end

  def partial_ref
      PartialRefParam.new
  end

  def file_ref(global_only = true, root_method = nil, directory = false)
      FileRefParam.new(global_only, root_method, directory)
  end

  def rel_ref
    one_of("alternate", "stylesheet", "start", "next", "prev", "contents", "index", "glossary", "copyright", "chapter", "section", "subsection", "appendix", "help", "bookmark", "tag")
  end

  def calculation_ref
      one_of(:average, :count, :maximum, :minimum, :sum)
  end

  def status_code_ref
      StatusCodeRefParam.new
  end

  def script_ref
      AssetRefParam.new(:getJavascriptsRootURL, "inspection.paramdef.script.warning", "javascripts")
  end

  def stylesheet_ref
      AssetRefParam.new(:getStylesheetsRootURL, "inspection.paramdef.stylesheet.warning", "stylesheets")
  end

  def table_name_ref
    TableNameRefParam.new
  end

  def table_column_type_ref
    types_strings = org.jetbrains.plugins.ruby.rails.codeInsight.ActiveRecordType::COLUMN_TYPES

    # convert string array to symbols array
    types_symbols = types_strings.collect {|item| item.to_sym}

    one_of_strings_or_symbols(*types_symbols)
  end

  def used_association_ref
      UsedAssociationRefParam.new
  end

  def view_ref(options = {})
      ViewRefParam.new((options.has_key? :root) ? ResolvingParamDependency.new(':' + options[:root].to_s) : nil)
  end

  def url_ref
    UrlRefParam.new
  end

  def before_filter_hash
    {
      :except => [action_with_children_ref, :*],
      :only => [action_with_children_ref, :*],
      :if => method_ref,
      :unless => method_ref
    }
  end

  def old_before_filter_hash
    {
      :except => [action_with_children_ref, :*],
      :only => [action_with_children_ref, :*]
    }
  end

  def active_record_finder_includes_list_item
    either({:enable_optional_keys => true}, used_association_ref)
  end

  def rbundle_msg (msg, *args)
    RBundle.message(msg, args.to_java(:"java.lang.String"))
  end
end
