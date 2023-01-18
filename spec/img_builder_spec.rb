require 'rspec/match_ignoring_whitespace'
require_relative '../lib/img_builder'
require_relative '../lib/img_props'

# Test ImgProperties
class ImgPropertiesTest
  RSpec.describe ImgBuilder do
    it 'generates an img' do
      props = ImgProperties.new
      props.src = 'blah.webp'
      builder = ImgBuilder.new(props)
      picture = <<~END_IMG
        <div class='imgWrapper' style=''>
          <picture class='imgPicture'>
            <source srcset="/assets/images/blah.webp" type="image/webp">
            <source srcset="/assets/images/blah.png" type="image/png">
            <img src="/assets/images/blah.png"
              class="imgImg rounded shadow"
              style='width: 100%; ' />
          </picture>
        </div>
      END_IMG

      expect(builder.send(:generate_figure_caption)).to be nil
      expect(builder.send(:generate_wrapper)).to        match_ignoring_whitespace(picture)
    end
  end
end
