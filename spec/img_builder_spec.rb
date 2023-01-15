require 'rspec/match_ignoring_whitespace'
require_relative '../lib/img_builder'
require_relative '../lib/img_props'

# Test ImgProperties
class ImgProperitesTest
  RSpec.describe ImgBuilder do # rubocop:disable Metrics/BlockLength
    it 'generates an img' do
      props = ImgProperties.new
      props.src = 'blah.webp'
      builder = ImgBuilder.new(props)
      expect(builder.send(:generate_img)).to match_ignoring_whitespace <<~END_IMG
        <picture>
          <source srcset="/assets/images/blah.webp" type="image/webp">
          <source srcset="/assets/images/blah.png" type="image/png">
          <img src="/assets/images/blah.png" class=" " />
        </picture>
      END_IMG
    end
  end
end