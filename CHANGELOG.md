# Change Log

## 0.2.0 / 2023-11-20

* Improved a messages.
* renamed `img` section in `_config.yml` to `jekyll_img`.
* renamed `continue_on_error` to `die_on_img_error`, reversed the meaning.
* added `pry_on_img_error`, which causes the `pry` debugger to be invoked when an `ImgError` is raised.
* Now dependant on `jekyll_plugin_support` v0.8.0 or later, which had several breaking changes.
* CSS for this plugin is now defined in `demo/assets/css/jekyll_img.css`.


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
