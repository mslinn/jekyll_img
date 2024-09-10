require 'rspec/match_ignoring_whitespace'
require_relative '../lib/source'

# Test ImgProperties
class ImgPropertiesTest
  RSpec.describe Source do
    it 'generates source fallback' do
      source = described_class.new('demo/assets/images/jekyll_240x103.webp')
      actual = source.src_fallback
      expect(actual).to eq("demo/assets/images/jekyll_240x103.png")
    end
  end
end
