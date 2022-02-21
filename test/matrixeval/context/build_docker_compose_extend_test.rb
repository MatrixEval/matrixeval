# frozen_string_literal: true

require 'test_helper'

class Matrixeval::Context::BuildDockerComposeExtendTest < MatrixevalTest

  def setup
    Matrixeval::Config::YAML.stubs(:yaml).returns({
      "docker-compose-extend" => {
        "volumes" => {
          "postgres12-<%= matrix_combination_id %>" => nil
        }
      }
    })

    @ruby_vector = Matrixeval::Vector.new("ruby", {"key" => "ruby"})
    @sidekiq_vector = Matrixeval::Vector.new("sidekiq", {"key" => "sidekiq"})
    @rails_vector = Matrixeval::Vector.new("rails", {"key" => "rails"})

    @ruby_3_variant = Matrixeval::Variant.new({"key" => "3.0"}, @ruby_vector)
    @sidekiq_5_variant = Matrixeval::Variant.new(
      {
        "key" => "5.0",
        "env" => {"SIDEKIQ_VERSION" => "5.0.0"}
      }, @sidekiq_vector)

    @rails_6_variant = Matrixeval::Variant.new(
      {
        "key" => "6.1",
        "env" => {"RAILS_VERSION" => "6.1.0"}
      }, @rails_vector)

    @context = Matrixeval::Context.new(
      main_variant: @ruby_3_variant,
      rest_variants: [@sidekiq_5_variant, @rails_6_variant]
    )
  end

  def test_call
    compose_extend = @context.docker_compose_extend
    assert compose_extend.is_a?(Matrixeval::DockerCompose::Extend)
    assert_equal({ "postgres12-ruby_3_0_rails_6_1_sidekiq_5_0" => nil }, compose_extend.volumes)
  end

end
