# Properties from user
# All methods are idempotent.
# attr_ methods can be called after compute_dependant_properties
# All methods except compute_dependant_properties can be called in any order
class ImgProperties
  attr_accessor :align, :alt, :attr_align_div, :attr_align_img, :caption, :classes, :id, :src, :size, :style, :target, :title, :url

  def attr_alt
    "alt='#{@alt}'" if @alt
  end

  def attr_classes
    @classes || 'liImg2 rounded shadow'
  end

  def attr_id
    "id='#{@id}'" if @id
  end

  def attr_nofollow
    " rel='nofollow'" if @nofollow
  end

  def attr_size_class
    if @size == 'initial'
      'initial'
    elsif size_unit_specified?
      nil
    else
      @size
    end
  end

  def attr_style
    "style='#{@style}'" if @style
  end

  def attr_target
    return nil if @target == 'none'

    target = @target || '_blank'
    " target='#{target}'"
  end

  def attr_title
    "title='#{@title}'" if @title && !@title.empty?
  end

  def attr_width
    "width: #{@size};" if @size
  end

  def compute_dependant_properties
    setup_align
    setup_src

    @target ||= '_blank'

    @alt ||= @caption || @title
    @title ||= @caption || @alt # rubocop:disable Naming/MemoizedInstanceVariableName
  end

  def src_png
    abort 'src parameter was not specified' if @src.to_s.empty?

    @src.gsub('.webp', '.png')
  end

  def self.local_path?(src)
    first_char = src[0]
    first_char.match?(%r{[./]})
  end

  private

  def setup_align
    if @align == 'inline'
      @attr_align_div = 'display: inline-block; margin: 0.5em; vertical-align: top;'
      @attr_align_img = nil
    elsif @align
      @attr_align_div = "text-align: #{@align};"
      @attr_align_img = @align
    else
      @attr_align_div = nil
      @attr_align_img = nil
    end
  end

  def setup_src
    @src = @src.to_s.strip
    abort 'src parameter was not specified' if @src.empty?

    @src = "/assets/images/#{@src}" unless ImgProperties.local_path?(@src) || url?(@src)
  end

  UNITS = %w[Q ch cm em dvh dvw ex in lh lvh lvw mm pc px pt rem rlh svh svw vb vh vi vmax vmin vw %].freeze

  def size_unit_specified?
    return false if @size.to_s.empty?

    @size.end_with?(*UNITS)
  end

  def url?(src)
    src.start_with? 'http'
  end
end
