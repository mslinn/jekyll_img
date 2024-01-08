# Like RoR's squish method
class String
  def squish
    strip.gsub(/\s+/, ' ')
  end
end

# Constructs HTML img tag from properties
class ImgBuilder
  def initialize(props)
    props.compute_dependant_properties
    @props = props
  end

  def to_s
    @props.compute_dependant_properties
    generate_wrapper
  end

  private

  def generate_wrapper
    classes = "imgWrapper #{@props.img_display} #{@props.align} #{@props.attr_size_class} #{@props.wrapper_class}".squish
    result = <<~END_HTML
      <div class='#{classes}' style='#{@props.attr_width_style} #{@props.wrapper_style}'>
        #{"<figure>\n" if @props.caption}
          #{ if @props.url
               "<a href='#{@props.url}'#{@props.attr_target}#{@props.attr_nofollow} class='imgImgUrl'>#{generate_img}</a>"
             else
               generate_img
             end
          }
          #{generate_figure_caption}
        #{"</figure>\n" if @props.caption}
        #{@props.attribute if @props.attribution}
      </div>
    END_HTML
    result.strip
  end

  def generate_figure_caption
    return nil unless @props.caption

    <<~END_CAPTION
      <figcaption class='imgFigCaption #{@props.attr_size_class}'>
        #{if @props.url
            <<~END_URL
              <a href="#{@props.url}" #{@props.attr_target} #{@props.attr_nofollow}>
                #{@props.caption}
              </a>
            END_URL
          else
            @props.caption
          end
        }
      </figcaption>
    END_CAPTION
  end

  # See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/picture
  def generate_img
    img_classes = @props.classes || 'rounded shadow'
    <<~END_IMG
      <picture#{@props.attr_id} class='imgPicture'>
        <source srcset="#{@props.src_any 'svg'}" type="image/svg">
        <!---<source srcset="#{@props.src_any 'avif'}" type="image/avif">-->
        <source srcset="#{@props.src}" type="image/webp">
        <source srcset="#{@props.src_any 'apng'}" type="image/apng">
        <source srcset="#{@props.src_any 'png'}" type="image/png">
        <source srcset="#{@props.src_any 'jpg'}" type="image/jpeg">
        <source srcset="#{@props.src_any 'jpeg'}" type="image/jpeg">
        <source srcset="#{@props.src_any 'jfif'}" type="image/jpeg">
        <source srcset="#{@props.src_any 'pjpeg'}" type="image/jpeg">
        <source srcset="#{@props.src_any 'pjp'}" type="image/jpeg">
        <source srcset="#{@props.src_any 'gif'}" type="image/gif">
        <source srcset="#{@props.src_any 'tif'}" type="image/tiff">
        <source srcset="#{@props.src_any 'tiff'}" type="image/tiff">
        <source srcset="#{@props.src_any 'bmp'}" type="image/bmp">
        <source srcset="#{@props.src_any 'ico'}" type="image/x-icon">
        <source srcset="#{@props.src_any 'cur'}" type="image/x-icon">
        <img #{@props.attr_alt}
          class="imgImg #{img_classes.squish}"
          src="#{@props.src_png}"
          #{@props.attr_style_img}
          #{@props.attr_title}
        />
      </picture>
    END_IMG
  end
end
