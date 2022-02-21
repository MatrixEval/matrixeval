# frozen_string_literal: true

require "test_helper"

class Matrixeval::DockerComposeTest < MatrixevalTest

  def test_context
    context = stub
    docker_compose = Matrixeval::DockerCompose.new(context)
    assert_equal context, docker_compose.context
  end

  def test_run
    Matrixeval::Config::YAML.stubs(:yaml).returns({"project_name" => "dummy app"})

    context = Matrixeval::Context.new(
      main_variant: Matrixeval::Variant.new(
        {
          "key" => "3.0",
          "image" => "ruby:3.0.0"
        },
        Matrixeval::Vector.new("ruby", {"key" => "ruby"})
      ),
      rest_variants: [
        Matrixeval::Variant.new(
          {
            "key" => "6.0",
            "env" => {
              "RAILS_VERSION" => "6.0.0"
            }
          },
          Matrixeval::Vector.new("rails", {"key" => "rails"})
        ),
        Matrixeval::Variant.new(
          {
            "key" => "5.0",
            "env" => {
              "SIDEKIQ_VERSION" => "5.0.0"
            }
          },
          Matrixeval::Vector.new("sidekiq", {"key" => "sidekiq"})
        ),
      ]
    )
    docker_compose = Matrixeval::DockerCompose.new(context)

    docker_compose.expects(:system).with(<<~COMMAND
      docker --log-level error compose \
      -f .matrixeval/docker-compose/ruby_3_0_rails_6_0_sidekiq_5_0.yml \
      -p matrixeval-dummy_app-ruby_3_0_rails_6_0_sidekiq_5_0 \
      run --rm --no-TTY \
      ruby_3_0 rake test
      COMMAND
    )

    docker_compose.expects(:system).with(<<~COMMAND.strip
      docker --log-level error compose \
      -f .matrixeval/docker-compose/ruby_3_0_rails_6_0_sidekiq_5_0.yml \
      -p matrixeval-dummy_app-ruby_3_0_rails_6_0_sidekiq_5_0 \
      stop >> /dev/null 2>&1
      COMMAND
    )

    docker_compose.expects(:system).with(<<~COMMAND.strip
      docker --log-level error compose \
      -f .matrixeval/docker-compose/ruby_3_0_rails_6_0_sidekiq_5_0.yml \
      -p matrixeval-dummy_app-ruby_3_0_rails_6_0_sidekiq_5_0 \
      rm -v -f >> /dev/null 2>&1
      COMMAND
    )

    docker_compose.expects(:system).with("stty opost")

    docker_compose.run(["rake", "test"])
  end

end
