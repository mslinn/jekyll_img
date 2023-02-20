require_relative '../lib/img_props'

class ImgProperitesTest
  RSpec.describe ImgProperties do
    it 'detects relative paths' do
      expect(described_class.local_path?('abcdef')).to be false
      expect(described_class.local_path?('./abc')).to  be true
      expect(described_class.local_path?('/abc')).to   be true
    end

    it 'has other class methods' do
      props = described_class.new
      expect(props.send(:size_unit_specified?)).to be false
      expect(props.send(:url?, 'blah')).to         be false
      expect(props.send(:url?, 'http://blah')).to  be true
    end

    it 'does not generate attributes for most empty properties' do
      props = described_class.new
      expect(props.attr_alt).to           be_nil
      expect(props.attr_img_classes).to   eq('rounded shadow')
      expect(props.attr_id).to            be_nil
      expect(props.attr_nofollow).to      be_nil
      expect(props.attr_size_class).to    be_nil
      expect(props.attr_style_img).to     eq("style='width: 100%; '")
      expect(props.attr_target).to        eq(" target='_blank'")
      expect(props.attr_title).to         be_nil
      expect(props.attr_width_style).to   be_nil

      props.compute_dependant_properties
      expect(props.attr_wrapper_align_class).to eq('inline')
    end

    it 'raises exception if src was not specified' do
      props = described_class.new
      expect { props.src_png }.to raise_error(SystemExit)
      expect { props.send(:setup_src) }.to raise_error(SystemExit)

      props.src = 'relative/path.webp'
      props.send(:setup_src)
      expect(props.src).to eq('/assets/images/relative/path.webp')

      props.src = './local/path.webp'
      props.send(:setup_src)
      expect(props.src).to eq('./local/path.webp')

      props.src = '/absolute/path.webp'
      props.send(:setup_src)
      expect(props.src).to eq('/absolute/path.webp')
    end

    it 'generates proper simple attributes' do
      props = described_class.new

      props.alt = 'blah'
      expect(props.attr_alt).to eq("alt='blah'")

      props.classes = 'blah'
      expect(props.attr_img_classes).to eq('blah')

      props.id = 'blah'
      expect(props.attr_id).to eq(" id='blah'")

      props.nofollow = true
      expect(props.attr_nofollow).to eq(" rel='nofollow'")

      props.size = 'initial'
      expect(props.attr_size_class).to eq('initial')

      props.size = '100px'
      expect(props.attr_size_class).to be_nil
      expect(props.attr_style_img).to eq("style='max-width: 100px;'")
      expect(props.attr_width_style).to eq('width: 100px;')

      props.size = '10%'
      expect(props.attr_size_class).to be_nil
      expect(props.attr_style_img).to eq("style='max-width: 10%;'")
      expect(props.attr_width_style).to eq('width: 10%;')

      props.size = 'fullsize'
      expect(props.attr_size_class).to eq('fullsize')
      expect(props.attr_width_style).to be_nil

      props.style = 'width: 30rem;'
      expect(props.attr_style_img).to eq("style='width: 30rem;'")

      props.target = 'moon'
      expect(props.attr_target).to eq(" target='moon'")

      props.title = 'The End'
      expect(props.attr_title).to eq("title='The End'")

      props.size = '100px'
      props.caption = 'A caption'
      expect(props.attr_size_class).to be_nil
      expect(props.attr_width_style).to eq('width: 100px;')
    end

    it 'generates proper alignment attributes' do
      props = described_class.new

      props.align = 'inline'
      props.compute_dependant_properties
      expect(props.attr_wrapper_align_class).to eq('inline')

      props.align = 'center'
      props.compute_dependant_properties
      expect(props.attr_wrapper_align_class).to eq('center')
    end
  end
end
