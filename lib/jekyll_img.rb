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
  # Usage: {% img [Options][src='path'] %}
  # Options are:
  #   align="left|inline|right|center"
  #   alt="Some text"
  #   caption="whatever"
  #   class="whatever"
  #   id="someId"
  #   nofollow
  #   size='fullsize|halfsize|initial|quartersize'
  #   style='css goes here'
  #   target='none|whatever'
  #   title="A title"
  #   url='https://blabla.com'
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

      html
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

    def html
      <<~END_HTML
        #{'<figure>' if figure}
        #{ if url
             "<a href='#{@url}' #{@targetTag} #{@nofollow}>#{@img}</a>"
           else
             img
           end }
          <figcaption class="#{@sizeClass}" style="width: 100%; text-align: center;">
            #{if url
                <<~END_URL
                  <a href="#{@url}" #{@targetTag} #{@nofollow}>
                    #{@caption}
                  </a>
                END_URL
              else
                @caption
              end }
          </figcaption>
          #{'</figure>' if figure}
      END_HTML
    end

    def id_setup
      @idTag = id.nil? ? '' : "id='#{id}'"
    end

    def img
      <<~END_IMG
        <picture#{@idTag}>
          <source srcset="#{@src}" type="image/webp">
          <source srcset="#{@srcPng}" type="image/png">
          <img src="#{@srcPng}" #{@titleTag} class="#{@alignImg} #{@sizeClass} #{@classes}" #{@styleTag} #{@altTag} />
        </picture>
        <div style="{{alignDiv}}{{sizeSpec}}">
          {% if figure %} <figure>{% endif %}
          {% if url %}
            <a href="{{url}}" {{targetTag}} {{nofollow}}>{{img}}</a>
          {% else %}
            {{img}}
          {% endif %}
        {% if caption %}
            <figcaption class="{{sizeClass}}" style="width: 100%; text-align: center;">
              {% if url %}
              <a href="{{url}}" {{targetTag}} {{nofollow}}>
                {{caption}}
              </a>
              {% else %}
                {{caption}}
              {% endif %}
            </figcaption>
          </figure>
        {% endif %}
        </div>
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
