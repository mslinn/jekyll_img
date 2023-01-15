# Properties from user
# All methods are idempotent.
# attr_ methods can be called after compute_dependant_properties
# All methods except compute_dependant_properties can be called in any order
class ImgProperties
  attr_accessor :align, :alt, :caption, :classes, :id, :src, :size, :style, :target, :title, :url

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

    " target='#{@target}'"
  end

  def attr_title
    "title='#{@title}'" if @title
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
    @src.gsub('.webp', '.png')
  end

  private

  def last_n_chars(string, n)
    string[-n..] || string
  end

  def relative_path?(src)
    first_char = src[0]
    first_char.match?(%r{[./]})
  end

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
    @src = @src.to_s.trim
    abort 'src parameter was not specified' if @src.empty?

    @src = "/assets/images/#{@src}" unless relative_path?(@src) || url?(@src)
  end

  def size_unit_specified?
    last_char = last_n_chars(@size, 1)
    last_2_chars = last_n_chars(@size, 2)
    %w[em px pt].include?(last_2_chars) || last_char == '%'
  end

  def url?(src)
    src.start_with? 'http'
  end
end
