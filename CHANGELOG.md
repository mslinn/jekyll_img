# Change Log

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
