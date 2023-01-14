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
  class Img < JekyllSupport::JekyllTag # rubocop:disable Metrics/AbcSize, Metrics/ClassLength
    attr_accessor :align, :alt, :caption, :class, :id, :src, :size, :style, :target, :title, :url

    def render_impl
      @align    = @helper.parameter_specified? 'align'
      @alt      = @helper.parameter_specified? 'alt'
      @caption  = @helper.parameter_specified? 'caption'
      @class    = @helper.parameter_specified? 'class'
      @nofollow = @helper.parameter_specified? 'nofollow'
      @src      = @helper.parameter_specified? 'src'
      @style    = @helper.parameter_specified? 'style'
      @size     = @helper.parameter_specified?('size') || @helper.parameter_specified?('_size')
      @target   = @helper.parameter_specified? 'target'
      @title    = @helper.parameter_specified? 'title'
      @url      = @helper.parameter_specified? 'url'

      abort 'src parameter was not specified' if @src.to_s.empty?
      src_setup

      align_setup
      alt_setup
      classes_setup
      id_setup
      nofollow_setup
      size_setup
      target_setup
      title_setup

      maybe_generate_figure
    end

    private

    def align_setup
      case @align
      when 'inline'
        @alignDiv = "display: inline-block; margin: 0.5em; vertical-align: top;"
        @alignImg = ''
      when @align
        @alignDiv = "text-align: #{@align};"
        @alignImg = @align
      else
        @alignDiv = ''
        @alignImg = ''
      end
    end

    def alt_setup
      @alt ||= @caption || @title
      @altTag = @alt.nil? ? '' : "alt='#{@alt}'"
    end

    def classes_setup
      @classes = @class || 'liImg2 rounded shadow'
    end

    def maybe_generate_figure
      <<~END_HTML
        #{'<div style="#{@alignDiv}#{@sizeSpec}">
            <figure>' if @caption}
            #{ if url
                  "<a href='#{@url}' #{@targetTag} #{@nofollow}>#{generate_img}</a>"
               else
                  generate_img
               end
            }
            #{fig_caption if @caption}
          #{'</figure>
        </div>' if @caption}
      END_HTML
    end

    def fig_caption
      <<~END_CAPTION
        <figcaption class='#{@sizeClass}' style='width: 100%; text-align: center;'>
          #{if url
              <<~END_URL
                <a href="#{@url}" #{@targetTag} #{@nofollow}>
                  #{@caption}
                </a>
              END_URL
            else
              @caption
            end
          }
        </figcaption>
      END_CAPTION
    end

    def id_setup
      @idTag = id.nil? ? '' : "id='#{id}'"
    end

    def generate_img
      <<~END_IMG
        <picture#{@idTag}>
          <source srcset="#{@src}" type="image/webp">
          <source srcset="#{@srcPng}" type="image/png">
          <img src="#{@srcPng}" #{@titleTag} class="#{@alignImg} #{@sizeClass} #{@classes}" #{@styleTag} #{@altTag} />
        </picture>
      END_IMG
    end

    def last_n_chars(string, n)
      string[-n..] || string
    end

    def nofollow_setup
      @nofollow = "rel='nofollow'" if @nofollow
    end

    def size_setup
      return unless @size

      sizeLast1 = last_n_chars(size, 1)
      sizeLast2 = last_n_chars(size, 2)
      if @size == 'initial'
        @sizeClass = 'initial'
      elsif ["em", "px", "pt"].include?(sizeLast2) || sizeLast1 == '%'
        @sizeClass = ''
        @sizeSpec = "width: #{@size}"
      elsif size
        @sizeClass = @size
      end
    end

    def src_setup
      @firstCharSrc = src[0]
      @protocol = src[0, 4]
      @src = "/assets/images/#{@src}" unless ['.', '/'].include?(firstCharSrc) || protocol == 'http'
      @srcPng = src.gsub('.webp', '.png')
    end

    def style_setup
      @styleTag = @style.nil? ? '' : "style='#{@style}'"
    end

    def target_setup
      if @target == 'none'
        @targetTag = ''
      else
        @target ||= '_blank'
        @targetTag = "target='#{@target}'"
      end
    end

    def title_setup
      @title ||= @caption || @alt
      @titleTag = "title='#{@title}'" if @title
    end
  end
end

PluginMetaLogger.instance.info { "Loaded #{ImgModule::PLUGIN_NAME} v0.1.0 plugin." }
Liquid::Template.register_tag(ImgModule::PLUGIN_NAME, Jekyll::Img)
