# Change Log

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
