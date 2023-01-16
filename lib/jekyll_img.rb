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
  # Usage: {% img [Options][src='path'|src=['path1', 'path2', 'pathN']] %}
  #   When src is specified as an array, the following options apply to the div
  #   that the images are enclosed within, unless they are also specified as arrays:
  #     align, alt, caption, url
  #
  # Options are:
  #   align="left|inline|right|center"
  #   alt="Alt text" # default is caption
  #   caption="A caption"
  #   classes="class1 class2 classN"
  #   id="someId"
  #   nofollow # Only applicable when url is specified
  #   size='eighthsize|fullsize|halfsize|initial|quartersize|XXXYY|XXX%' # XXX is a float, YY is unit
  #   style='css goes here'
  #   target='none|whatever' # default is _blank
  #   title="A title" # default is caption
  #   url='https://domain.com'
  #   wrapper_class='class1 class2'
  #   wrapper_style='color: red;'
  #
  # unit is one of: Q ch cm em dvh dvw ex in lh lvh lvw mm pc px pt rem rlh svh svw vb vh vi vmax vmin vw
  # _size is an alias for size; it applies to the entire generated construct
  class Img < JekyllSupport::JekyllTag
    def render_impl
      props = ImgProperties.new
      props.align         = @helper.parameter_specified? 'align'
      props.alt           = @helper.parameter_specified? 'alt'
      props.caption       = @helper.parameter_specified? 'caption'
      props.classes       = @helper.parameter_specified? 'class'
      props.id            = @helper.parameter_specified? 'id'
      props.nofollow      = @helper.parameter_specified? 'nofollow'
      props.size          = @helper.parameter_specified?('size') || @helper.parameter_specified?('_size')
      props.src           = @helper.parameter_specified? 'src'
      props.style         = @helper.parameter_specified? 'style'
      props.target        = @helper.parameter_specified? 'target'
      props.title         = @helper.parameter_specified? 'title'
      props.url           = @helper.parameter_specified? 'url'
      props.wrapper_class = @helper.parameter_specified? 'wrapper_class'
      props.wrapper_style = @helper.parameter_specified? 'wrapper_style'

      @builder = ImgBuilder.new(props)
      @builder.to_s
    end
  end
end

PluginMetaLogger.instance.info { "Loaded #{ImgModule::PLUGIN_NAME} v0.1.0 plugin." }
Liquid::Template.register_tag(ImgModule::PLUGIN_NAME, Jekyll::Img)
