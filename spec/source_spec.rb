require 'rspec/match_ignoring_whitespace'
require_relative '../lib/source'

# Test ImgProperties
class ImgPropertiesTest
  RSpec.describe Source do
    source = described_class.new('demo/assets/images/jekyll_240x103.webp')

    it 'globs paths' do
      expect(source.send(:globbed_path)).to eq("demo/assets/images/jekyll_240x103.*")
    end

    it 'sorts files' do
      actual = source.send(:sorted_files)
      desired = [
        "demo/assets/images/jekyll_240x103.webp",
        "demo/assets/images/jekyll_240x103.png",
        "demo/assets/images/jekyll_240x103.jpg",
        "demo/assets/images/jekyll_240x103.gif",
        "demo/assets/images/jekyll_240x103.txt"
      ]
      expect(actual).to eq(desired)
    end

    it 'generates mimetype' do
      expect(source.send(:mimetype, 'blah.png')).to  eq('image/png')
      expect(source.send(:mimetype, 'blah.svg')).to  eq('image/svg')
      expect(source.send(:mimetype, 'blah.webp')).to eq('image/webp')
      expect(source.send(:mimetype, 'blah.gif')).to  eq('image/gif')
      expect(source.send(:mimetype, 'blah.blah')).to be_nil
    end

    it 'generates source fallback' do
      expect(source.src_fallback).to eq("demo/assets/images/jekyll_240x103.png")
    end

    it 'generates sources' do
      actual = source.generate.join("\n")
      desired = <<~END_DESIRED
        <source srcset="demo/assets/images/jekyll_240x103.webp" type="image/webp">
        <source srcset="demo/assets/images/jekyll_240x103.png" type="image/png">
        <source srcset="demo/assets/images/jekyll_240x103.gif" type="image/gif">
      END_DESIRED
      expect(actual).to match_ignoring_whitespace(desired)
    end
  end
end
