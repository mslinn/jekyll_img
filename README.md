`jekyll_img`
[![Gem Version](https://badge.fury.io/rb/jekyll_img.svg)](https://badge.fury.io/rb/jekyll_img)
===========

`jekyll_img` is a Jekyll plugin that displays formatted quotes.

See [demo/index.html](demo/index.html) for examples.
Styles referenced by the jekyll_img plugin are at the bottom of [demo/assets/css/style.css](demo/assets/css/style.css)


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
