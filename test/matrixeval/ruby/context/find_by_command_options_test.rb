# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::Context::FindByCommandOptionsTest < MatrixevalTest

  def setup
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({
      "version" => "0.3",
      "target" => "ruby",
      "matrix" => {
        "ruby" => {
          "variants" => [
            { "key" => "3.0", "default" => true },
            { "key" => "3.1" }
          ]
        },
        "rails" => {
          "variants" => [
            { "key" => "6.1" },
            { "key" => "7.0", "default" => true }
          ]
        },
        "sidekiq" => {
          "variants" => [
            { "key" => "5.0" },
            { "key" => "6.0", "default" => true }
          ]
        }
      }
    })
  end

  def test_find_by_command_options
    context = Matrixeval::Ruby::Context.find_by_command_options!({ruby: "3.1"})

    assert context.is_a?(Matrixeval::Ruby::Context)
    assert_equal "ruby", context.main_variant.vector.key
    assert_equal "3.1", context.main_variant.key
    assert_equal "rails", context.rest_variants[0].vector.key
    assert_equal "7.0", context.rest_variants[0].key
    assert_equal "sidekiq", context.rest_variants[1].vector.key
    assert_equal "6.0", context.rest_variants[1].key
  end

  def test_find_by_command_options_fail
    assert_raises "Can't find a corresponding matrix" do
      Matrixeval::Ruby::Context.find_by_command_options!({ruby: "wrong"})
    end
  end

end
