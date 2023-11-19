require 'jekyll_plugin_support'
require 'jekyll_plugin_helper'
require_relative 'img_builder'
require_relative 'img_props'
require_relative 'jekyll_img/version'

# @author Copyright 2023 Michael Slinn
# @license SPDX-License-Identifier: Apache-2.0

module ImgModule
  PLUGIN_NAME = 'img'.freeze
end

module Jekyll
  # Plugin implementation
  class Img < JekyllSupport::JekyllTag
    include JekyllImgVersion

    def render_impl
      @helper.gem_file __FILE__ # This enables plugin attribution

      config = @config['img']
      @continue_on_error = config['continue_on_error'] == true if config

      props = ImgProperties.new
      props.attribute         = @helper.attribute
      props.attribution       = @helper.attribution
      props.align             = @helper.parameter_specified?('align') || 'inline'
      props.alt               = @helper.parameter_specified? 'alt'
      props.caption           = @helper.parameter_specified? 'caption'
      props.classes           = @helper.parameter_specified? 'class'
      props.continue_on_error = @continue_on_error
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
      e.shorten_backtrace
      msg = format_error_message e.message
      @logger.error "#{e.class} raised #{msg}"
      raise e if @die_on_custom_error

      "<div class='custom_error'>#{e.class} raised in #{self.class};\n#{msg}</div>"
    end

    JekyllPluginHelper.register(self, ImgModule::PLUGIN_NAME)
  end
end
