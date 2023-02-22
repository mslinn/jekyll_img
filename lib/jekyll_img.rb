require 'jekyll_plugin_support'
require 'jekyll_plugin_support_helper'
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

    def render_impl # rubocop:disable Metrics/AbcSize
      config = @config['img']
      @continue_on_error = config['continue_on_error'] == true if config

      props = ImgProperties.new
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
    rescue ImgError => e
      msg = <<~END_ERR
        #{e.message} on line #{@line_number} (after front matter) of #{@page['path']}.
        The offending argument string was: #{@argument_string}
      END_ERR
      raise ImgError, msg.red, [] unless @continue_on_error

      @logger.warn msg
    end

    JekyllPluginHelper.register(self, ImgModule::PLUGIN_NAME)
  end
end
