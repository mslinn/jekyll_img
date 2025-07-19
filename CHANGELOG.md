# Change Log

## 0.2.9 / 2025-05-19

* `max-width` option added.
* `width` option added as an alias for `size`.
  This requires new CSS classes to be defined:
  `max_eighthsize`, `max_fullsize`, `max_halfsize`, and `max_quartersize`.
* More CSS classes defined and more tests added to the Demo app to support `max-width`.

## 0.2.8 / 2025-05-16

* An image can now be lazily loaded by providing the `lazy` keyword.
* An image can now be fetched with high priority by providing the `priority` keyword.


## 0.2.7 / 2024-09-11

* Further tweaking of the generated HTML.


## 0.2.6 / 2024-09-10

* Optimized the generated HTML.
  For example, `srcset` elements are now only generated for images that actually exit locally.
  For remote images, only an `img` element is generated for the specified filetype.
  The tests can be found in `demo/img_test.html`.


## 0.2.5 / 2024-07-23

* Depends on jekyll_plugin_support v1.0.2
* Error handling improved
* Corrected `README.md#Configuration` and fixed demo `_config.yml`
  so they correctly specify error handling for this plugin:

  ```ruby
  img:
    die_on_img_error: false
    pry_on_img_error: false
  ```


## 0.2.4 / 2024-07-23

* Depends on jekyll_plugin_support v1.0.0


## 0.2.3 / 2024-04-27

* Depends on jekyll_plugin_support v0.8.5


## 0.2.2 / 2024-01-08

* Added support for all image types except `avif`.


## 0.2.1 / 2023-11-28

* Took care of the inevitable blunder when making too many changes


## 0.2.0 / 2023-11-20

* The [demo/](demo/) webapp has been upgraded to the latest features.
* Improved error messages.
* Renamed the `img` section of `_config.yml` to `jekyll_img`.
* Renamed `continue_on_error` to `die_on_img_error` and reversed the meaning.
* Now dependant on `jekyll_plugin_support` v0.8.0 or later, which had several breaking changes.
* CSS for this plugin is now defined in `demo/assets/css/jekyll_img.css`.
* Added a `pry_on_img_error` setting, which causes the `pry` debugger to be invoked when an `ImgError` is raised.
  `pry` is now opened when an `ImgError` is raised if `_config.yml` contains:

  ```yaml
  jekyll_img:
    pry_on_img_error: true
  ```


## 0.1.6 / 2023-08-10

* `.webp` file type is assumed and no longer needs to be specified.
  For example, instead of writing this:

  ```html
  {% img src="blah.webp" %}
  ```

  You can now write:

  ```html
  {% img src="blah" %}
  ```


## 0.1.5 / 2023-05-30

* Updated dependencies


## 0.1.4 / 2023-04-02

* Added [`attribution` support](https://github.com/mslinn/jekyll_plugin_support#subclass-attribution).
* Fixed `style=' false'` that appeared when the `style` and `wrapper_style` attributes were not provided.


## 0.1.3 / 2023-02-22

* Added `img/continue_on_error` configuration parameter.


## 0.1.2 / 2023-02-14

* Fixed `img_props.rb:91:in size_unit_specified?: undefined method end_with? for false:FalseClass (NoMethodError)`


## 0.1.1 / 2023-02-12

* Initial release
