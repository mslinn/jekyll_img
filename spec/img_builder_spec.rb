require 'rspec/match_ignoring_whitespace'
require_relative '../lib/img_builder'
require_relative '../lib/img_props'
require_relative '../lib/source'

class ImgTest
  attr_accessor :page, :cite, :url

  def initialize
    @page = { 'path' => 'mypage.html' }
    @cite = 'this is a cite'
    @url  = 'http://localhost:4001/mypage.html'
  end
end

class ImgPropertiesTest
  RSpec.describe ImgBuilder do
    Dir.chdir("demo")
    props = ImgProperties.new
    props.src = '/assets/images/jekyll.webp'
    img = ImgTest.new
    builder = described_class.new(img, props)

    it 'generates sources' do
      actual = builder.source.generate
      expected = [
        '<source srcset="/assets/images/jekyll.webp" type="image/webp">',
        '<source srcset="/assets/images/jekyll.png" type="image/png">'
      ]
      expect(actual).to match_array(expected)
    end

    it 'generates a figcaption' do
      expected = <<~END_STRING
        <figcaption class='imgFigCaption '>
        </figcaption>
      END_STRING
      expect(builder.generate_figcaption).to match_ignoring_whitespace(expected)
    end

    it 'generates a picture' do
      expected = <<~END_DESIRED
        <picture class='imgPicture'>
          <source srcset="/assets/images/jekyll.webp" type="image/webp">
          <source srcset="/assets/images/jekyll.png" type="image/png">
          <img class="imgImg rounded shadow"
            src="/assets/images/jekyll.png"
            style='width: 100%; '
          />
        </picture>
      END_DESIRED
      actual = builder.generate_picture
      expect(actual).to match_ignoring_whitespace(expected)
    end

    it 'generates a default img' do
      expected = <<~END_IMG
        <div class='imgWrapper imgFlex' style=''>
          <picture class='imgPicture'>
            <source srcset="/assets/images/jekyll.webp" type="image/webp">
            <source srcset="/assets/images/jekyll.png" type="image/png">
            <img class="imgImg rounded shadow"
              src="/assets/images/jekyll.png"
              style='width: 100%; '
            />
          </picture>
        </div>
      END_IMG

      actual = builder.generate_wrapper
      expect(actual).to match_ignoring_whitespace(expected)
    end

    it 'generates an img wrapper with size and caption' do
      props.caption = 'This is a caption'
      props.size = '123px'
      builder = described_class.new(img, props)

      caption = <<~END_CAPTION
        <figcaption class='imgFigCaption '>
          This is a caption
        </figcaption>
      END_CAPTION

      expected = <<~END_IMG
        <div class='imgWrapper imgBlock' style='width: 123px;'>
          <figure>
            <picture class='imgPicture'>
              <source srcset="/assets/images/jekyll.webp" type="image/webp">
              <source srcset="/assets/images/jekyll.png" type="image/png">
              <img alt='This is a caption'
                class="imgImg rounded shadow"
                src="/assets/images/jekyll.png"
                style='width: 100%; '
                title='This is a caption'
              />
            </picture>
            #{caption}
          </figure>
        </div>
      END_IMG

      actual = builder.generate_wrapper
      expect(actual).to match_ignoring_whitespace(expected)
    end
  end
end
