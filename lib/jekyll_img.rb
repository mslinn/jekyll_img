# frozen_string_literal: true

require 'jekyll_plugin_support'
require 'jekyll_plugin_support_helper'
require_relative 'jekyll_img/version'

# @author Copyright 2023 Michael Slinn
# @license SPDX-License-Identifier: Apache-2.0

module ImgModule
  PLUGIN_NAME = 'img'
end

module Jekyll
  # Usage: {% img [Options][src='path'|src=['path1', 'path2', 'pathN']] %}
  #   When src is specified as an array, the following options apply to the div
  #   that the images are enclosed within, unless they are also specified as arrays:
  #     align, alt, caption, url
  #
  # Options are:
  #   align="left|inline|right|center"
  #   alt="Alt text" # default is caption
  #   alt=["Alt text 1", "Alt text 2", "Alt text N"]
  #   caption="A caption"
  #   caption=["Caption 1", "Caption 2", "Caption N"]
  #   class="class1 class2 classN"
  #   id="someId"
  #   nofollow # Only applicable when url is specified
  #   size='fullsize|halfsize|initial|quartersize|XXXYY' # XXX is a float, YY is unit
  #   style='css goes here'
  #   target='none|whatever' # default is _blank
  #   title="A title" # default is caption
  #   url='https://domain.com'
  #   url='[https://domain1.com, https://domain2.com, https://domainN.com]'
  #
  # _size is an alias for size
  class Img < JekyllSupport::JekyllTag
    def render_impl # rubocop:disable Metrics/AbcSize
      props = ImgProperties.new
      props.align    = @helper.parameter_specified? 'align'
      props.alt      = @helper.parameter_specified? 'alt'
      props.caption  = @helper.parameter_specified? 'caption'
      props.classes  = @helper.parameter_specified? 'class'
      props.nofollow = @helper.parameter_specified? 'nofollow'
      props.src      = @helper.parameter_specified? 'src'
      props.style    = @helper.parameter_specified? 'style'
      props.size     = @helper.parameter_specified?('size') || @helper.parameter_specified?('_size')
      props.target   = @helper.parameter_specified? 'target'
      props.title    = @helper.parameter_specified? 'title'
      props.url      = @helper.parameter_specified? 'url'

      @builder = ImgBuilder.new(props)
      @builder.to_s
    end
  end
end

PluginMetaLogger.instance.info { "Loaded #{ImgModule::PLUGIN_NAME} v0.1.0 plugin." }
Liquid::Template.register_tag(ImgModule::PLUGIN_NAME, Jekyll::Img)
