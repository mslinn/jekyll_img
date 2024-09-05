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
               "<a href='#{@props.url}'#{@props.attr_target}#{@props.attr_nofollow} class='imgImgUrl'>#{generate_image}</a>"
             else
               generate_image
             end
          }
          #{generate_figure_caption}
        #{"</figure>\n" if @props.caption}
        #{@props.attribute if @props.attribution}
      </div>
    END_HTML
    result.strip.gsub(/^\s*$\n/, '')
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

  # @return Array[String] containing HTML source elements
  def generate_sources(filetypes, mimetype)
    return '' if @src.nil? || @src.start_with?('http')

    result = filetypes.map do |ftype|
      filename = @props.src_any ftype
      next unless File.exist?("./#{filename}")

      <<~END_HTML
        <source srcset="#{filename}" type="#{mimetype}">
      END_HTML
    end
    result&.compact&.map(&:strip)
  end

  def generate_compact_sources
    [
      generate_sources(%w[svg], 'image/svg'),
      generate_sources(%w[webp], 'image/webp'),
      generate_sources(%w[png], 'image/png'),
      generate_sources(%w[apng], 'image/apng'),
      generate_sources(%w[jpg jpeg jfif pjpeg pjp], 'image/jpeg'),
      generate_sources(%w[gif], 'image/gif'),
      generate_sources(%w[tif tiff], 'image/tiff'),
      generate_sources(%w[bmp], 'image/bmp'),
      generate_sources(%w[cur ico], 'image/x-icon')
    ].compact.join("\n").strip.gsub(/^$\n/, '')
  end

  # See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/picture
  def generate_image
    return generate_img if @props.src.start_with? 'http'

    # avif is not well supported yet
    # <source srcset="#{@props.src_any 'avif'}" type="image/avif">
    result = <<~END_IMG
      <picture#{@props.attr_id} class='imgPicture'>
        #{generate_compact_sources}
        #{generate_img}
      </picture>
    END_IMG
    result.strip
  end

  def generate_img
    img_classes = @props.classes || 'rounded shadow'
    <<~END_IMG
      <img #{@props.attr_alt}
        class="imgImg #{img_classes.squish}"
        src="#{@props.src_fallback}"
        #{@props.attr_style_img}
        #{@props.attr_title}
      />
    END_IMG
  end
end
