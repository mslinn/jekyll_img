# Properties from user
# attr_ methods can be called after finalize
# All methods are idempotent except finalize
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
    elsif size_units_specified?
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

  def finalize
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
    first_char = @src[0]
    protocol = @src[0, 4]
    @src = "/assets/images/#{@src}" unless ['.', '/'].include?(first_char) || protocol == 'http'
  end

  def size_units_specified?
    last_char = last_n_chars(@size, 1)
    last_2_chars = last_n_chars(@size, 2)
    %w[em px pt].include?(last_2_chars) || last_char == '%'
  end
end
