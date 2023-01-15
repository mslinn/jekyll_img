require 'rspec/match_ignoring_whitespace'
require_relative '../lib/img_props'

# Test ImgProperties
class ImgProperitesTest
  RSpec.describe ImgProperties do # rubocop:disable Metrics/BlockLength
    it 'detects relative paths' do
      expect(ImgProperties.local_path?('abcdef')).to be false
      expect(ImgProperties.local_path?('./abc')).to be true
      expect(ImgProperties.local_path?('/abc')).to be true
    end

    it 'has other class methods' do
      props = ImgProperties.new
      expect(props.send(:size_unit_specified?)).to be false
      expect(props.send(:url?, 'blah')).to         be false
      expect(props.send(:url?, 'http://blah')).to  be true
    end

    it 'does not generate attributes for most empty properties' do
      props = ImgProperties.new
      expect(props.attr_alt).to        be nil
      expect(props.attr_classes).to    eq('liImg2 rounded shadow')
      expect(props.attr_id).to         be nil
      expect(props.attr_nofollow).to   be nil
      expect(props.attr_size_class).to be nil
      expect(props.attr_style).to      be nil
      expect(props.attr_target).to     eq(" target='_blank'")
      expect(props.attr_title).to      be nil
      expect(props.attr_width).to      be nil

      props.send(:setup_align)
      expect(props.attr_align_div).to be nil
      expect(props.attr_align_img).to be nil
    end

    it 'raises exception if src was not specified' do
      props = ImgProperties.new
      expect { props.src_png }.to raise_error(SystemExit)
    end

    it 'generates proper alignment attributes' do
      props = ImgProperties.new

      props.align = 'inline'
      props.send(:setup_align)
      expect(props.attr_align_div).to eq('display: inline-block; margin: 0.5em; vertical-align: top;')
      expect(props.attr_align_img).to be nil

      props.align = 'center'
      props.send(:setup_align)
      expect(props.attr_align_div).to eq('text-align: center;')
      expect(props.attr_align_img).to eq('center')
    end
  end
end