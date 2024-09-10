class String
  def remove_blank_lines
    strip.gsub(/^\s*$\n/, '')
  end

  # Like RoR's squish method
  def squish
    strip.gsub(/\s+/, ' ')
  end
end

# Constructs HTML img tag from properties
class ImgBuilder
  attr_reader :source

  def initialize(props)
    props.compute_dependant_properties
    @props = props
    @source = Source.new @props.src
  end

  def generate_figcaption
    <<~END_CAPTION
      <figcaption class='imgFigCaption #{@props.attr_size_class}'>
        #{@props.url ? generate_url_caption : @props.caption}
      </figcaption>
    END_CAPTION
  end

  def generate_img
    img_classes = @props.classes || 'rounded shadow'
    <<~END_IMG
      <img #{@props.attr_alt}
        class="imgImg #{img_classes.squish}"
        src="#{@source.src_fallback}"
        #{@props.attr_style_img}
        #{@props.attr_title}
      />
    END_IMG
  end

  # See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/picture
  def generate_picture
    return generate_img if @props.src.start_with? 'http'

    # avif is not well supported yet
    # <source srcset="#{@props.src_any 'avif'}" type="image/avif">
    result = <<~END_IMG
      <picture#{@props.attr_id} class='imgPicture'>
        #{@source.generate.join("\n  ")}
        #{generate_img}
      </picture>
    END_IMG
    result.strip
  end

  def generate_url_caption
    <<~END_URL
      <a href="#{@props.url}"#{@props.attr_target}#{@props.attr_nofollow}>
        #{@props.caption}
      </a>
    END_URL
  end

  def generate_url_wrapper
    <<~END_HTML
      <a href='#{@props.url}'#{@props.attr_target}#{@props.attr_nofollow} class='imgImgUrl'>
        #{generate_picture}
      </a>
    END_HTML
  end

  def generate_wrapper
    classes = "imgWrapper #{@props.img_display} #{@props.align} #{@props.attr_size_class} #{@props.wrapper_class}".squish
    <<~END_HTML.remove_blank_lines
      <div class='#{classes}' style='#{@props.attr_width_style} #{@props.wrapper_style}'>
        #{"<figure>\n" if @props.caption}
          #{@props.url ? generate_url_wrapper : generate_picture}
          #{generate_figcaption}
        #{"</figure>\n" if @props.caption}
        #{@props.attribute if @props.attribution}
      </div>
    END_HTML
  end

  def to_s
    @props.compute_dependant_properties
    generate_wrapper
  end
end
