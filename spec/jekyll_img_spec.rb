require 'jekyll'
require 'jekyll_plugin_logger'
require 'rspec/match_ignoring_whitespace'
require_relative '../lib/jekyll_img'

Registers = Struct.new(:page, :site)

# Mock for Collections
class Collections
  def values
    []
  end
end

# Mock for Site
class SiteMock
  attr_reader :config

  def collections
    Collections.new
  end
end

# Mock for Liquid::ParseContent
class TestParseContext < Liquid::ParseContext
  attr_reader :line_number, :registers

  def initialize
    super
    @line_number = 123

    @registers = Registers.new(
      {},
      SiteMock.new
    )
  end
end

# These tests all fail because I have not figured out how to provide a Jekyll block body to a test
class MyTest
  RSpec.describe Jekyll::Img do
    let(:logger) do
      PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
    end

    let(:parse_context) { TestParseContext.new }

    let(:helper) do
      JekyllPluginHelper.new(
        'img',
        'src="./blah.webp"',
        logger
      )
    end

    it 'has no cite or url' do
      helper.reinitialize('src="./blah.webp"')
      img = described_class.send(
        :new,
        'img',
        helper.markup.dup,
        parse_context
      )
      result = img.send(:render_impl, helper.markup)
      expect(result).to match_ignoring_whitespace <<-END_RESULT
        <img src="./blah.webp">
      END_RESULT
    end
  end
end
