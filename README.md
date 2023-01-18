`jekyll_img`
[![Gem Version](https://badge.fury.io/rb/jekyll_img.svg)](https://badge.fury.io/rb/jekyll_img)
===========

`Jekyll_img` is a Jekyll plugin that displays images,
and provides support for captions and URLs.

See [demo/index.html](demo/index.html) for examples.


## Usage
    {% img [Options] src='path' %}

`Options` are:

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

[`unit`](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#numbers_lengths_and_percentages) is one of: `Q`, `ch`, `cm`, `em`, `dvh`, `dvw`, `ex`, `in`, `lh`,
`lvh`, `lvw`, `mm`, `pc`, `px`, `pt`, `rem`, `rlh`, `svh`, `svw`, `vb`,
`vh`, `vi`, `vmax`, `vmin`, or `vw`.

CSS classes referenced by the `jekyll_img` plugin are at the bottom of [demo/assets/css/style.css](demo/assets/css/style.css). CSS marker classes are included, so CSS selectors can be used for additional styling.


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
Handling all possible situations of these two scenarios would significantly raise the complexity of the plugin code. I know, because I went down that rabbit hole.


### Wrapper &lt;div /&gt;
To make the plugin code more manageable,
the plugin always encloses the generated HTML & CSS within a wrapper `<div />`.
The wrapper allows for a simple, consistent approach regardless of whether a caption is generated or not.

The wrapper width is identical to the displayed image width.
Within the wrapper `<div />`, the embedded `<img />` is displayed with `width=100%`.
If a caption is required, the generated `<figure />` only makes the space taken by the generated HTML longer;
the image width and height is not affected.

The wrapper will not exceed the width of the tag that encloses it if the `size` parameter has values `eighthsize`, `fullsize`, `halfsize`, `initial` or `quartersize`.

The wrapper's width can be defined independently of its enclosing tag by using [CSS units](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/Values_and_units#numbers_lengths_and_percentages) for the `size` parameter:
`Q`, `ch`, `cm`, `em`, `dvh`, `dvw`, `ex`, `in`, `lh`,
`lvh`, `lvw`, `mm`, `pc`, `px`, `pt`, `rem`, `rlh`, `svh`, `svw`, `vb`,
`vh`, `vi`, `vmax`, `vmin`, or `vw`.
Using CSS units means that large enough values could cause the image to exceed the width of its enclosing tag.


## Installation

Add this line to your Jekyll project's Gemfile, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_img'
end
```

Also add it to `_config.yml`:
```yaml
plugins:
  - jekyll_img
```

And then execute:

    $ bundle install


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
