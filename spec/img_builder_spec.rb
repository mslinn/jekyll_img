require 'rspec/match_ignoring_whitespace'
require_relative '../lib/img_builder'
require_relative '../lib/img_props'

# Test ImgProperties
class ImgPropertiesTest
  RSpec.describe ImgBuilder do
    Dir.chdir("demo")

    it 'generates sources' do
      props = ImgProperties.new
      props.src = 'jekyll.webp'
      builder = described_class.new(props)
      actual = builder.send(:generate_sources, ['png'], 'image/png')
      expect(actual).to contain_exactly('<source srcset="/assets/images/jekyll.png" type="image/png">')
    end

    it 'generates a default img' do
      props = ImgProperties.new
      props.src = 'jekyll.webp'
      builder = described_class.new(props)
      picture = <<~END_IMG
        <div class='imgWrapper imgFlex' style=' '>
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

      expect(builder.send(:generate_figure_caption)).to be_nil
      expect(builder.send(:generate_wrapper)).to        match_ignoring_whitespace(picture)
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

      expect(builder.send(:generate_figure_caption)).to match_ignoring_whitespace(caption)
      expect(builder.send(:generate_wrapper)).to        match_ignoring_whitespace(picture)
    end
  end
end
