# `jekyll_img` [![Gem Version](https://badge.fury.io/rb/jekyll_img.svg)](https://badge.fury.io/rb/jekyll_img)


`Jekyll_img` is a Jekyll plugin that embeds images in HTML documents, with alignment options,
flexible resizing, default styling, overridable styling, an optional caption, an optional URL,
and optional fullscreen zoom on mouseover.

Muliple image formats are supported for each image.
The user&rsquo;s web browser determines the formats which it will accept.
The most desirable formats that the web browser supports are prioritized.

For example, if an image is encloded in `webp`, `png` and `gif` filetypes,
and the user&rsquo;s web browser is relatively recent,
then `webp` format will give the fastest transmission and look best.
Older browsers, which might not support `webp` format,
would give best results for `png` format.
Really old web browsers would only support the `gif` file type.

Please read the next section for details.

I explain why the `webp` image format is important in
[Converting All Images in a Website to `webp` Format](https://mslinn.com/blog/2020/08/15/converting-all-images-to-webp-format.html).
That article also provides 2 bash scripts for converting existing images to and from <code>webp</code> format.

See [demo/index.html](demo/index.html) for examples.


## External Images

Images whose `src` attribute starts with `http` are not served from the Jekyll website.
The `jekyll_img` plugin generates HTML for external images using an `img` element with a `src`
attribute as you might expect.


## Image Fallback

For local files (files served from the Jekyll website),
the `jekyll_img` plugin generates HTML that falls back to successively less performant
formats.
This is made possible by using a
[`picture`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/picture) element.

At least one version of every image are required.
Supported filetypes are:
`svg`, `webp`, `apng`, `png`, `jpg`, `jpeg`, `jfif`, `pjpeg`, `pjp`, `gif`, `tif`, `tiff`, `bmp`, `ico` and `cur`.

For example, an image file might have the following verions: `blah.webp`, `blah.png` and `blah.jpg`.
Given a tag invocation like `{% img src='blah.webp' %}`,
the plugin would generate a `picture` element that contains an `img` sub-element with the given `src` attribute,
and a `source` element for each related image (`blah.png` and `blah.jpg`).
Conceptually, the generated HTML might look something like this:

```html
<picture>
  <source srcset="blah.png" />
  <source srcset="blah.jpg" />
  <img src="blah.webp" />
</picture>
```

If no filetype is given for the image, `webp` is assumed.
For example, these two invocations yield the same result,
if `blah.webp` exists on the Jekyll website:

```html
{% img src="blah" %}
{% img src="blah.webp" %}
```

If both `blah.webp` and `blah.png` were available,
the above would fetch and display `blah.webp` if the web browser supported `webp` format,
otherwise it would fetch and display `blah.png`.
If the browser did not support the `picture` element,
the `img src` attribute would be used to specify the image.


### Default and Relative Paths

Local images whose path does not start with a slash are assumed to be relative to `/assets/images`.
Simply specifying the filename of the image will cause it to be fetched from
`/assets/images/`.
For example, the following all fetch the same image:

```html
{% img src="/assets/images/blah.webp" %}
{% img src="blah.webp" %}
{% img src="blah" %}
```

To specify an image in a subdirectory of where the page resides,
prepend the relative path with a dot (`.`).

For example, if the current page resides in a [Jekyll collection](https://jekyllrb.com/docs/collections/)
with path `/collections/_av_studio/`,
and an image resides in the `/collections/_av_studio/images` subdirectory,
the following would result in the same image being displayed:

```html
{% img src="/av_studio/images/blah" %}
{% img src="./images/blah" %}
```

### Lazy Loading

An image can be lazily loaded by providing the `lazy` keyword.
This feature relies upon the lazy loading capability built into all modern browsers and does not rely upon JavaScript.

From [Browser-level image lazy loading for the web](https://web.dev/articles/browser-level-image-lazy-loading#dimension-attributes)
on `web.dev`:

> While the browser loads an image, it doesn't immediately know the image's dimensions,
> unless they're explicitly specified.
> To let the browser reserve enough space on a page for images, and avoid disruptive layout shifts,
> we recommend adding width and height attributes to all  tags.
>
> &lt;img src="image.png" loading="lazy" alt="…" width="200" height="200">
Alternatively, specify their values directly in an inline style:
>
> &lt;img src="image.png" loading="lazy" alt="…" style="height:200px; width:200px;">

This would translate to:

```html
{% img lazy
  src="blah.webp"
  style="height:200px; width:200px"
%}
```

Note that the image must be fetched in order for HTML `img` attributes `height='auto'` and `width='auto'` to work.
Thus lazy loading is incompatible with a dimension whose value is specified as `auto`.
This means that, for lazily loaded images,
`height` and `width` must have values that are computable without loading the image.
Because the Jekyll `img` tag's `size` attribute only specifies the `width` attribute,
and sets `height` to `auto`, it should not be used with the `lazy` keyword.

The following examples of implicit and explicit `auto` dimensions will all give problems:

```html
{% img lazy
  size="200px"
  src="blah.webp"
%}

{% img lazy
  src="blah.webp"
  style="height:auto; width:200px"
%}

{% img lazy
  src="blah.webp"
  style="height:200px; width:auto"
%}

{% img lazy
  src="blah.webp"
  style="height:200px"
%}

{% img lazy
  src="blah.webp"
  style="width:200px"
%}
```


### High Priority Loading

An image can be fetched with high priority by providing the `priority` keyword.

Sample usage:

```html
{% img priority src="blah.webp" style="height:200px; width:200px" %}
```

From [Browser-level image lazy loading for the web](https://web.dev/articles/browser-level-image-lazy-loading#loading-priority)
on `web.dev`:

> If you want to increase the fetch priority of an important image, use fetchpriority="high".
>
> An image with loading="lazy" and fetchpriority="high" is still delayed while it's off-screen,
> and then fetched with a high priority when it's almost within the viewport.
> This combination isn't really necessary because the browser would likely load that image with high priority anyway.


Note that the image must be fetched in order for `img` attributes `height='auto'` and `width='auto'` to work.
This means that `height` and `width` must have values that are computable without loading the image.
Because the `img` tag's `size` attribute only specifies the `width` attribute, and sets `height` to `auto`,
it should not be used.

Sample usage combining lazy loading:

```html
{% img lazy priority src="blah.webp" style="height:200px; width:200px" %}
```


## Supported Filetypes

The following are listed in order of priority.
See [MDN](https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Image_types) for more information.

| Filetype                              | MIME type       |
| ------------------------------------- | --------------- |
| `svg`                                 | `image/svg+xml` |
| `avif`                                | `image/avif`    |
| `webp`                                | `image/webp`    |
| `apng`                                | `image/apng`    |
| `png`                                 | `image/png`     |
| `jpg`, `jpeg`, `jfif`, `pjpeg`, `pjp` | `image/jpeg`    |
| `gif`                                 | `image/gif`     |
| `tif`, `tiff`                         | `image/tiff`    |
| `bmp`                                 | `image/bmp`     |
| `ico`, `cur`                          | `image/x-icon`  |

Because `avif` is problematic as of 2024-01-08 on Firefox, Chrome and Safari, it is not supported yet.


## Demo

Run the demo website by typing:

```shell
$ demo/_bin/debug -r
```

... and point your web browser to http://localhost:4011


## Usage

```html
{% img [Options] src='path' %}
```

`Options` are:

- `attribution` See [`jekyll_plugin_support`](https://github.com/mslinn/jekyll_plugin_support#subclass-attribution).
- `align="left|inline|right|center"` Default value is `inline`
- `alt="Alt text"` Default value is the `caption` text, if provided
- `caption="A caption"` No default value
- `classes="class1 class2 classN"` Extra &lt;img&gt; classes; default is `rounded shadow`
- `id="someId"` No default value
- `nofollow`  Generates `rel='nofollow'`; only applicable when `url` is specified
- `size='eighthsize|fullsize|halfsize|initial|quartersize|XXXYY|XXX%'`
   Defines width of image.
  - `initial` is the default behavior.
  - `eighthsize`, `fullsize`, `halfsize`, and `quartersize` are relative to the enclosing tag's width.
  - CSS units can also be used, for those cases `XXX` is a float and `YY` is `unit` (see below)
- `style='css goes here'` CSS style for &lt;img&gt;; no default
- `target='none|whatever'` Only applicable when `url` is specified; default value is `_blank`
- `title="A title"` Default value is `caption` text, if provided
- `url='https://domain.com'` No default value
- `wrapper_class='class1 class2 classN'` Extra CSS classes for wrapper &lt;div&gt;; no default value
- `wrapper_style='background-color: black;'` CSS style for wrapper &lt;div&gt;; no default value
- `zoom` Fullscreen zoom on mouseover; presse escape or click outside image to dismiss

[`unit`](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#numbers_lengths_and_percentages)
is one of: `Q`, `ch`, `cm`, `em`, `dvh`, `dvw`, `ex`, `in`, `lh`,
`lvh`, `lvw`, `mm`, `pc`, `px`, `pt`, `rem`, `rlh`, `svh`, `svw`, `vb`,
`vh`, `vi`, `vmax`, `vmin`, or `vw`.

CSS classes referenced by the `jekyll_img` plugin are in
[`demo/assets/css/jekyll_img.css`](demo/assets/css/jekyll_img.css) and
[`demo/assets/css/jekyll_plugin_support.css`](demo/assets/css/jekyll_plugin_support.css).
CSS marker classes are included, so CSS selectors can be used for additional styling.


## Configuration

By default, errors cause Jekyll to abort.
You can allow Jekyll to halt by setting the following in `_config.yml`:

```yaml
img:
  die_on_img_error: true
  pry_on_img_error: true
```


## Design

The most significant design issue was the decision that image size and formatting should not change
whether it had a caption.
HTML captions exist within a `<figure />` element, which also surrounds the image.

I also wanted to ensure that captions would wrap text under an image,
and would not be wider than the image they were associated with.

CSS behavior differs for `<figure />` and `<img />`.
For example, centering, floating right and left.
That means the CSS and where it would need to be applied are completely different for
naked `<img />` and `<figure />` tags.
Handling all possible situations of these two scenarios would significantly raise the complexity of the plugin code.
I know, because I went down that rabbit hole.


### Wrapper &lt;div /&gt;

To make the plugin code more manageable,
the plugin always encloses the generated HTML & CSS within a wrapper `<div />`.
The wrapper allows for a simple, consistent approach regardless of whether a caption is generated or not.

The wrapper width is identical to the displayed image width.
Within the wrapper `<div />`, the embedded `<img />` is displayed with `width=100%`.
If a caption is required, the generated `<figure />` only makes the space taken by the generated HTML longer;
the image&rsquo;s width and height are not affected.

The wrapper will not exceed the width of the tag that encloses it if the `size` parameter has values
`eighthsize`, `fullsize`, `halfsize`, `initial` or `quartersize`.

The wrapper's width can be defined independently of its enclosing tag by using
[CSS units](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#numbers_lengths_and_percentages)
for the `size` parameter:
`Q`, `ch`, `cm`, `em`, `dvh`, `dvw`, `ex`, `in`, `lh`,
`lvh`, `lvw`, `mm`, `pc`, `px`, `pt`, `rem`, `rlh`, `svh`, `svw`, `vb`,
`vh`, `vi`, `vmax`, `vmin`, or `vw`.
Using CSS units means that large enough values could cause the image to exceed the width of its enclosing tag.


## Installation

Add this line to your Jekyll project's `Gemfile`, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_img'
end
```

And then execute:

```shell
$ bundle
```


## Additional Information

More information is available on
[Mike Slinn&rsquo;s website](https://www.mslinn.com/blog/2020/10/03/jekyll-plugins.html).


## Development

After checking out the repo, run `bin/setup` to install dependencies.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.


To build and install this gem onto your local machine, run:

```shell
$ bundle exec rake install
jekyll_img 0.1.0 built to pkg/jekyll_img-0.1.0.gem.
jekyll_img (0.1.0) installed.
```

Examine the newly built gem:

```shell
$ gem info jekyll_img

*** LOCAL GEMS ***

jekyll_img (0.1.0)
    Author: Mike Slinn
    Homepage:
    https://github.com/mslinn/jekyll_img
    License: MIT
    Installed at: /home/mslinn/.gems

    Generates Jekyll logger with colored output.
```


### Debugging

You can cause `pry` to open when an `ImgError` is raised by setting `pry_on_img_error` in `_config.yml`.
`Pry_on_img_error` has priority `die_on_img_error`.

```yaml
jekyll_img:
  die_on_img_error: false # Default value is false
  pry_on_img_error: true # Default value is false
```


### Testing

Examine the output by running:

```shell
$ demo/_bin/debug -r
```

... and pointing your web browser to http://localhost:4444/

### Unit Tests

Either run `rspec` from Visual Studio Code's *Run and Debug* environment
(<kbd>Ctrl</kbd>-<kbd>shift</kbd>-<kbd>D</kbd>) and view the *Debug Console* output,
or run it from the command line:

```shell
$ rspec
```

### Build and Push to RubyGems

To release a new version,

1. Update the version number in `version.rb`.
2. Commit all changes to git; if you don't the next step might fail with an unexplainable error message.
3. Run the following:

   ```shell
   $ bundle exec rake release
   ```

     The above creates a git tag for the version, commits the created tag,
     and pushes the new `.gem` file to [RubyGems.org](https://rubygems.org).


## Contributing

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
