require 'jekyll_plugin_support'
require 'helper/jekyll_plugin_helper'
require 'pry'
require_relative 'img_builder'
require_relative 'img_props'
require_relative 'jekyll_img/version'

# @author Copyright 2023 Michael Slinn
# @license SPDX-License-Identifier: Apache-2.0

module ImgModule
  PLUGIN_NAME = 'img'.freeze unless const_defined?(:PLUGIN_NAME)
end

module Jekyll
  ImgError = ::JekyllSupport.define_error unless const_defined?(:ImgError)

  # Plugin implementation
  class Img < ::JekyllSupport::JekyllTag
    include JekyllImgVersion

    def render_impl
      @helper.gem_file __FILE__ # This enables plugin attribution

      @die_on_img_error = @tag_config['die_on_img_error'] == true if @tag_config
      @pry_on_img_error = @tag_config['pry_on_img_error'] == true if @tag_config

      props = ImgProperties.new
      props.attribute         = @helper.attribute
      props.attribution       = @helper.attribution
      props.align             = @helper.parameter_specified?('align') || 'inline'
      props.alt               = @helper.parameter_specified? 'alt'
      props.caption           = @helper.parameter_specified? 'caption'
      props.classes           = @helper.parameter_specified? 'class'
      props.die_on_img_error  = @die_on_img_error
      props.id                = @helper.parameter_specified? 'id'
      props.nofollow          = @helper.parameter_specified? 'nofollow'
      props.size              = @helper.parameter_specified?('size') || @helper.parameter_specified?('_size')
      props.src               = @helper.parameter_specified? 'src'
      props.style             = @helper.parameter_specified? 'style'
      props.target            = @helper.parameter_specified? 'target'
      props.title             = @helper.parameter_specified? 'title'
      props.url               = @helper.parameter_specified? 'url'
      props.wrapper_class     = @helper.parameter_specified? 'wrapper_class'
      props.wrapper_style     = @helper.parameter_specified? 'wrapper_style'

      @builder = ImgBuilder.new(props)
      @builder.to_s
    rescue ImgError => e # jekyll_plugin_support handles StandardError
      @logger.error { e.logger_message }
      binding.pry if @pry_on_img_error # rubocop:disable Lint/Debugger
      exit! 1 if @die_on_img_error

      e.html_message
    end

    ::JekyllSupport::JekyllPluginHelper.register(self, ImgModule::PLUGIN_NAME) unless $PROGRAM_NAME.end_with?('/rspec')
  end
end
