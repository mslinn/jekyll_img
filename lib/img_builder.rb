# Constructs HTML img tag from properties
class ImgBuilder
  def initialize(props)
    @props = props
  end

  def to_s
    @props.finalize
    maybe_generate_figure
  end

  private

  # rubocop:disable Style/MultilineIfModifier
  def maybe_generate_figure
    <<~END_HTML
      #{"<div style='#{@props.attr_align_div}#{@props.attr_width}'>
          <figure>" if @props.caption}
          #{ if @props.url
               "<a href='#{@props.url}'#{@props.attr_target}#{@props.attr_nofollow}>#{generate_img}</a>"
             else
               generate_img
             end
          }
          #{generate_figure_caption if @props.caption}
        #{'</figure>
      </div>' if @props.caption}
    END_HTML
  end
  # rubocop:enable Style/MultilineIfModifier

  def generate_figure_caption
    <<~END_CAPTION
      <figcaption class='#{@props.attr_size_class}' style='width: 100%; text-align: center;'>
        #{if url
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

  def generate_img
    <<~END_IMG
      <picture#{@props.attr_id}>
        <source srcset="#{@props.src}" type="image/webp">
        <source srcset="#{@props.src_png}" type="image/png">
        <img src="#{@props.src_png}" #{@props.attr_title} class="#{@props.attr_align_img} #{@props.attr_size_class} #{@props.classes}" #{@props.attr_style} #{@props.attr_alt} />
      </picture>
    END_IMG
  end
end
