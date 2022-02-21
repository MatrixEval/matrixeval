# frozen_string_literal: true

require "test_helper"

class Matrixeval::CommandLine::ParseContextArgumentsTest < MatrixevalTest

  def setup
    Matrixeval::Config::YAML.stubs(:yaml).returns({
      "version" => "0.3",
      "target" => "ruby",
      "matrix" => {
        "ruby" => {
          "main" => true,
          "variants" => [
            { "key" => "3.0", "default" => true },
            { "key" => "3.1" }
          ]
        },
        "active_model" => {
          "variants" => [
            { "key" => "6.1", "default" => true },
            { "key" => "7.0" }
          ]
        }
      }
    })
  end

  def test_call
    context_arguments = ["--ruby", "3.0"]
    options = Matrixeval::CommandLine::ParseContextArguments.call(context_arguments)
    assert_equal "3.0", options[:ruby]
    assert_nil options[:active_model]
  end

end
