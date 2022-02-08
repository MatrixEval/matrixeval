# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::DockerComposeTest < MatrixevalTest

  def test_context
    context = stub
    docker_compose = Matrixeval::Ruby::DockerCompose.new(context)
    assert_equal context, docker_compose.context
  end

  def test_run
    context = Matrixeval::Ruby::Context.new(
      main_variant: Matrixeval::Ruby::Variant.new(
        {
          "key" => "3.0",
          "image" => "ruby:3.0.0"
        },
        Matrixeval::Ruby::Vector.new("ruby", {"key" => "ruby"})
      ),
      rest_variants: [
        Matrixeval::Ruby::Variant.new(
          {
            "key" => "6.0",
            "env" => {
              "RAILS_VERSION" => "6.0.0"
            }
          },
          Matrixeval::Ruby::Vector.new("rails", {"key" => "rails"})
        ),
        Matrixeval::Ruby::Variant.new(
          {
            "key" => "5.0",
            "env" => {
              "SIDEKIQ_VERSION" => "5.0.0"
            }
          },
          Matrixeval::Ruby::Vector.new("sidekiq", {"key" => "sidekiq"})
        ),
      ]
    )
    docker_compose = Matrixeval::Ruby::DockerCompose.new(context)
    expected_docker_compose_command = <<~COMMAND
      docker compose -f .matrixeval/docker-compose.yml \
      run --rm \
      -e RAILS_VERSION=6.0.0 \
      -e SIDEKIQ_VERSION=5.0.0 \
      -v ./.matrixeval/Gemfile.lock.ruby_3_0_rails_6_0_sidekiq_5_0:/app/Gemfile.lock \
      ruby_3_0 \
      rake test
      COMMAND
    docker_compose.expects(:system).with(expected_docker_compose_command)
    docker_compose.run(["rake", "test"])
  end

end
