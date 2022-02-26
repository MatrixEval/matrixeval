# MatrixEval

Test your code against multiple versions of dependencies like:
- Programming language version
- Framework version
- Package version
- Environment variables

## Features

- Parallel test your code against multiple versions of dependencies combinations.
- Test your code against a specific dependencies combination.
- Choose any docker image you like for each job.
- Easy to use CLI to speed up your development efficiency
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'matrixeval'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install matrixeval

### Plugins

If you plan to test ruby code, you can use [matrixeval-ruby](https://github.com/MatrixEval/matrixeval-ruby) directly.

## Usage

Initialize

```bash
matrixeval init
```

Customize `matrixeval.yml` file and run commands like:

```bash
matrixeval --all COMMAND
matrixeval --PROGRAMMING_LANGUAGE LANGUAGE_VERSION --PACKAGE_NAME PACKAGE_VERSION COMMAND OPTIONS
matrixeval bash
```
Run `matrixeval --help` for more details

### Configuration Example

Here is the configuration file `matrixeval.yml` which will auto created by `matrixeval init`

```yaml
version: 0.4
project_name: REPLACE_ME
parallel_workers: number_of_processors
# commands:
#   - ps
#   - top
#   - an_additional_command
# mounts:
#   - /a/path/need/to/mount:/a/path/mount/to
matrix:
  # YOUR_PROGRAMMING_LANGUAGE_NAME:
  #   main: true
  #   variants:
  #     - key: LANGUAGE_VERSION_1
  #       default: true
  #       container:
  #         image: LANGUAGE_DOCKER_NAME_1
  #     - key: LANGUAGE_VERSION_2
  #       container:
  #         image: LANGUAGE_DOCKER_NAME_2
  #       env:
  #           AN_ENV_KEY: ENV_VALUE
  #       mounts:
  #         - /a/path/need/to/mount:/a/path/mount/to

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
  # - YOUR_PROGRAMMING_LANGUAGE_NAME: LANGUAGE_VERSION_1
  #   another: key1

docker-compose-extend:
  # services:
  #   postgres:
  #     image: postgres:12.8
  #     volumes:
  #       - postgres12:/var/lib/postgresql/data
  #     environment:
  #       POSTGRES_HOST_AUTH_METHOD: trust

  #   redis:
  #     image: redis:6.2-alpine

  # volumes:
  #   postgres12:
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/matrixeval/matrixeval. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/matrixeval/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Matrixeval::Ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/matrixeval/matrixeval/blob/main/CODE_OF_CONDUCT.md).
