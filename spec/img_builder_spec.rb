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

    it 'generates sources 1' do
      actual = builder.source.generate
      expect(actual).to contain_exactly('<source srcset="./assets/images/jekyll.png" type="image/png">',
                                        '<source srcset="./assets/images/jekyll.webp" type="image/webp">')
    end

    it 'generates a figcaption' do
      expect(builder.send(:generate_figcaption)).to eq("<figcaption class='imgFigCaption '>\n  \n</figcaption>\n")
    end

    it 'generates a default img' do
      picture = <<~END_IMG
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

      expect(builder.generate_wrapper).to match_ignoring_whitespace(picture)
    end

    it 'generates an img with size and caption' do
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

      picture = <<~END_IMG
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

      expect(builder.generate_figcaption).to match_ignoring_whitespace(caption)
      expect(builder.generate_wrapper).to match_ignoring_whitespace(picture)
    end
  end
end
