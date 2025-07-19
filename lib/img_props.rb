require 'uri'

# Properties from user
# All methods are idempotent.
# attr_ methods can be called after compute_dependant_properties
# All methods except compute_dependant_properties can be called in any order
class ImgProperties
  attr_accessor :align, :alt, :attr_wrapper_align_class, :attribute, :attribution, :caption, :classes, :die_on_img_error,
                :id, :img_display, :lazy, :local_src, :max_width, :nofollow, :priority, :src, :size, :style,
                :target, :title, :url, :wrapper_class, :wrapper_style

  SIZES = %w[eighthsize fullsize halfsize initial quartersize].freeze
  UNITS = %w[Q ch cm em dvh dvw ex in lh lvh lvw mm pc px pt rem rlh svh svw vb vh vi vmax vmin vw %].freeze

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

  def attr_max_width_class
    return nil if @max_width == false || @max_width.nil? || max_width_unit_specified?

    unless SIZES.include?(@max_width)
      msg = "'#{@max_width}' is not a recognized size; must be one of #{SIZES.join(', ')}, or an explicit unit."
      raise Jekyll::ImgError, msg
    end
    "max_#{@max_width}"
  end

  def attr_size_class
    return nil if @size == false || @size.nil? || size_unit_specified?

    unless SIZES.include?(@size)
      msg = "'#{@size}' is not a recognized size; must be one of #{SIZES.join(', ')}, or an explicit unit."
      raise Jekyll::ImgError, msg
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

  def attr_max_width_style
    "max-width: #{@max_width};" if max_width_unit_specified?
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

  def src_any(filetype)
    @src.gsub(/\..*?$/, ".#{filetype}")
  end

  def self.local_path?(src)
    first_char = src[0]
    first_char.match?(%r{[./]})
  end

  private

  def setup_src
    raise Jekyll::ImgError, "The 'src' parameter was not specified" if @src.nil? || [true, false].include?(@src)

    raise Jekyll::ImgError, "The 'src' parameter was empty" if @src.empty?

    @src = @src.to_s.strip
    raise Jekyll::ImgError, "The 'src' parameter only contained whitespace" if @src.empty?

    filetype = File.extname(URI(@src).path)
    @src += '.webp' if filetype.empty?

    @src = "/assets/images/#{@src}" unless ImgProperties.local_path?(@src) || url?(@src)
    # return unless ImgProperties.local_path?(@src)

    # src = @src.start_with?('/') ? ".#{@src}" : @src
    # raise Jekyll::ImgError, "#{@src} does not exist" unless File.exist?(src)
  end

  def max_width_unit_specified?
    max_width_not_specified = @max_width == false || @max_width.to_s.strip.empty?
    return false if max_width_not_specified

    @max_width&.end_with?(*UNITS)
  end

  def size_unit_specified?
    size_not_specified = @size == false || @size.to_s.strip.empty?
    return false if size_not_specified

    @size&.end_with?(*UNITS)
  end

  def url?(src)
    src.start_with? 'http'
  end
end
