require 'rspec/match_ignoring_whitespace'
require_relative '../lib/source'

# Test ImgProperties
class ImgPropertiesTest
  RSpec.describe Source do
    Dir.chdir("#{__dir__}/../demo")
    source_absolute = described_class.new('/assets/images/jekyll_240x103.webp')
    source_relative = described_class.new('./assets/images/jekyll_240x103.webp')

    it 'globs absolute paths' do
      expect(source_absolute.send(:globbed_path)).to eq("./assets/images/jekyll_240x103.*")
    end

    it 'globs relative paths' do
      expect(source_relative.send(:globbed_path)).to eq("./assets/images/jekyll_240x103.*")
    end

    it 'sorts files with absolute path' do
      actual = source_absolute.send(:sorted_files)
      desired = [
        "/assets/images/jekyll_240x103.webp",
        "/assets/images/jekyll_240x103.png",
        "/assets/images/jekyll_240x103.jpg",
        "/assets/images/jekyll_240x103.gif",
        "/assets/images/jekyll_240x103.txt"
      ]
      expect(actual).to eq(desired)
    end

    it 'sorts files with relative path' do
      actual = source_relative.send(:sorted_files)
      desired = [
        "./assets/images/jekyll_240x103.webp",
        "./assets/images/jekyll_240x103.png",
        "./assets/images/jekyll_240x103.jpg",
        "./assets/images/jekyll_240x103.gif",
        "./assets/images/jekyll_240x103.txt"
      ]
      expect(actual).to eq(desired)
    end

    it 'generates mimetype for absolute paths' do
      expect(source_absolute.send(:mimetype, 'blah.png')).to  eq('image/png')
      expect(source_absolute.send(:mimetype, 'blah.svg')).to  eq('image/svg')
      expect(source_absolute.send(:mimetype, 'blah.webp')).to eq('image/webp')
      expect(source_absolute.send(:mimetype, 'blah.gif')).to  eq('image/gif')
      expect(source_absolute.send(:mimetype, 'blah.blah')).to be_nil
    end

    it 'generates mimetype for relative paths' do
      expect(source_relative.send(:mimetype, 'blah.png')).to  eq('image/png')
      expect(source_relative.send(:mimetype, 'blah.svg')).to  eq('image/svg')
      expect(source_relative.send(:mimetype, 'blah.webp')).to eq('image/webp')
      expect(source_relative.send(:mimetype, 'blah.gif')).to  eq('image/gif')
      expect(source_relative.send(:mimetype, 'blah.blah')).to be_nil
    end

    it 'generates source fallback for absolute paths' do
      expect(source_absolute.src_fallback).to eq("/assets/images/jekyll_240x103.png")
    end

    it 'generates source fallback for relative paths' do
      expect(source_relative.src_fallback).to eq("./assets/images/jekyll_240x103.png")
    end

    it 'generates sources for absolute paths' do
      actual = source_absolute.generate.join("\n")
      desired = <<~END_DESIRED
        <source srcset="/assets/images/jekyll_240x103.webp" type="image/webp">
        <source srcset="/assets/images/jekyll_240x103.png" type="image/png">
        <source srcset="/assets/images/jekyll_240x103.gif" type="image/gif">
      END_DESIRED
      expect(actual).to match_ignoring_whitespace(desired)
    end

    it 'generates sources for relative paths' do
      actual = source_relative.generate.join("\n")
      desired = <<~END_DESIRED
        <source srcset="./assets/images/jekyll_240x103.webp" type="image/webp">
        <source srcset="./assets/images/jekyll_240x103.png" type="image/png">
        <source srcset="./assets/images/jekyll_240x103.gif" type="image/gif">
      END_DESIRED
      expect(actual).to match_ignoring_whitespace(desired)
    end
  end
end
