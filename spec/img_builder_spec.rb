require 'rspec/match_ignoring_whitespace'
require_relative '../lib/img_builder'
require_relative '../lib/img_props'
require_relative '../lib/source'

# Test ImgProperties
class ImgPropertiesTest
  RSpec.describe ImgBuilder do
    Dir.chdir("demo")
    props = ImgProperties.new
    props.src = './assets/images/jekyll.webp'
    builder = described_class.new(props)

    it 'generates sources' do
      actual = builder.source.generate
      desired = [
        '<source srcset="./assets/images/jekyll.webp" type="image/webp">',
        '<source srcset="./assets/images/jekyll.png" type="image/png">'
      ]
      expect(actual).to match_array(desired)
    end

    it 'generates a figcaption' do
      desired = <<~END_STRING
        <figcaption class='imgFigCaption '>
        </figcaption>
      END_STRING
      expect(builder.generate_figcaption).to match_ignoring_whitespace(desired)
    end

    it 'generates a picture' do
      desired = <<~END_DESIRED
        <picture class='imgPicture'>
          <source srcset="./assets/images/jekyll.webp" type="image/webp">
          <source srcset="./assets/images/jekyll.png" type="image/png">
          <img class="imgImg rounded shadow"
            src="./assets/images/jekyll.png"
            style='width: 100%; '
          />
        </picture>
      END_DESIRED
      actual = builder.generate_picture
      expect(actual).to match_ignoring_whitespace(desired)
    end

    it 'generates a default img' do
      desired = <<~END_IMG
        <div class='imgWrapper imgFlex' style=' '>
          <picture class='imgPicture'>
            <source srcset="./assets/images/jekyll.webp" type="image/webp">
            <source srcset="./assets/images/jekyll.png" type="image/png">
            <img class="imgImg rounded shadow"
              src="./assets/images/jekyll.png"
              style='width: 100%; '
            />
          </picture>
        </div>
      END_IMG

      actual = builder.generate_wrapper
      expect(actual).to match_ignoring_whitespace(desired)
    end

    it 'generates an img wrapper with size and caption' do
      props = ImgProperties.new
      props.caption = 'This is a caption'
      props.size = '123px'
      props.src = 'jekyll.webp'
      builder = described_class.new(props)

      caption = <<~END_CAPTION
        <figcaption class='imgFigCaption '>
          This is a caption
        </figcaption>
      END_CAPTION

      desired = <<~END_IMG
        <div class='imgWrapper imgBlock' style='width: 123px; '>
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

      expect(builder.generate_wrapper).to match_ignoring_whitespace(desired)
    end
  end
end
