# matrixeval-ruby

Test your ruby code against multiple versions of dependencies like Ruby, Rails, Env ...

![](https://raw.githubusercontent.com/MatrixEval/assets/main/screenshots/summary.png)

## Features

- Parallel test your ruby code against multiple versions of dependencies combinations.
- Test your ruby code against a specific dependencies combination.
- Choose any docker image you like for each job.
- Easy to use CLI to speed up your development efficiency
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'matrixeval-ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install matrixeval-ruby

## Usage

Initialize

```bash
matrixeval init
```

Customize `matrixeval.yml` file and run commands like:

```bash
matrixeval --all bundle install
matrixeval --all rspec
matrixeval --ruby 3.0 rspec a_spec.rb
matrixeval --ruby 3.1 --rails 7.0 rake test
matrixeval bash
```
Run `matrixeval --help` for more details

![](https://raw.githubusercontent.com/MatrixEval/assets/main/screenshots/help.png)

### Configuration Example

Here is the configuration file `matrixeval.yml` which will auto created by `matrixeval init`

```yaml
version: 0.3
project_name: REPLACE_ME
target: ruby
parallel_workers: number_of_processors
# commands:
#   - ps
#   - top
#   - an_additional_command
# mounts:
#   - /a/path/need/to/mount:/a/path/mount/to
matrix:
  ruby:
    variants:
      - key: 2.7
        container:
          image: ruby:2.7.1
      - key: 3.0
        default: true
        container:
          image: ruby:3.0.0
      - key: 3.1
        container:
          image: ruby:3.1.0
      # - key: jruby-9.3
      #   container:
      #     image: jruby:9.3
      #   env:
      #       PATH: "/opt/jruby/bin:/app/bin:/bundle/bin:$PATH"
      #   mounts:
      #     - /a/path/need/to/mount:/a/path/mount/to

  # rails:
  #   variants:
  #     - key: 6.1
  #       default: true
  #       env:
  #         RAILS_VERSION: "~> 6.1.0"
  #     - key: 7.0
  #       env:
  #         RAILS_VERSION: "~> 7.0.0"
  # another:
  #   variants:
  #     - key: key1
  #       default: true
  #       env:
  #         ENV_KEY: 1
  #     - key: key2
  #       env:
  #         ENV_KEY: 2

exclude:
  # - ruby: 3.0
  #   rails: 4.2
  # - ruby: jruby-9.3
  #   rails: 7.0
```

### Gemfile configuration example

Here is an example from [ruby-trello](https://github.com/jeremytregunna/ruby-trello)

```ruby
if active_model_version = ENV['ACTIVE_MODEL_VERSION']
  gem 'activemodel', active_model_version
end
```

You can also check its corresponding [`matrixeval.yml`](https://github.com/jeremytregunna/ruby-trello/blob/master/matrixeval.yml)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/matrixeval/matrixeval-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/matrixeval-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Matrixeval::Ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/matrixeval/matrixeval-ruby/blob/main/CODE_OF_CONDUCT.md).
