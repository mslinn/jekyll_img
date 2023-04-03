class ImgError < StandardError; end

# Properties from user
# All methods are idempotent.
# attr_ methods can be called after compute_dependant_properties
# All methods except compute_dependant_properties can be called in any order
class ImgProperties
  attr_accessor :align, :alt, :attr_wrapper_align_class, :attribute, :attribution, :caption, :classes, :continue_on_error, \
                :id, :img_display, :nofollow, :src, :size, :style, :target, :title, \
                :url, :wrapper_class, :wrapper_style

  SIZES = %w[eighthsize fullsize halfsize initial quartersize].freeze

  def attr_alt
    "alt='#{@alt}'" if @alt
  end

  def attr_id
    " id='#{@id}'" if @id
  end

  # <img> tag assets, except alignment classes (inline, left, center, right)
  def attr_img_classes
    @classes || 'rounded shadow'
  end

  def attr_nofollow
    " rel='nofollow'" if @nofollow
  end

  def attr_size_class
    return nil if @size == false || @size.nil? || size_unit_specified?

    unless SIZES.include?(@size)
      msg = "'#{@size}' is not a recognized size; must be one of #{SIZES.join(', ')}, or an explicit unit."
      raise ImgError, msg
    end
    @size
  end

  def attr_style_img
    "style='width: 100%; #{@style}'".squish
  end

  def attr_target
    return nil if @target == 'none'

    target = @target || '_blank'
    " target='#{target}'"
  end

  def attr_title
    "title='#{@title}'" if @title && !@title.empty?
  end

  def attr_width_style
    "width: #{@size};" if size_unit_specified?
  end

  def compute_dependant_properties
    setup_src

    @target ||= '_blank'

    @img_display = @caption && @size ? 'imgBlock' : 'imgFlex'

    @alt   ||= @caption || @title
    @title ||= @caption || @alt
  end

  def src_png
    raise ImgError, "The 'src' parameter was not specified" if @src.to_s.empty?

    @src.gsub('.webp', '.png')
  end

  def self.local_path?(src)
    first_char = src[0]
    first_char.match?(%r{[./]})
  end

  private

  def setup_src
    @src = @src.to_s.strip
    raise ImgError, "The 'src' parameter was not specified", [] if @src.empty?

    @src = "/assets/images/#{@src}" unless ImgProperties.local_path?(@src) || url?(@src)
  end

  UNITS = %w[Q ch cm em dvh dvw ex in lh lvh lvw mm pc px pt rem rlh svh svw vb vh vi vmax vmin vw %].freeze

  def size_unit_specified?
    return false if @size == false || @size.to_s.strip.empty?

    @size.end_with?(*UNITS)
  end

  def url?(src)
    src.start_with? 'http'
  end
end
