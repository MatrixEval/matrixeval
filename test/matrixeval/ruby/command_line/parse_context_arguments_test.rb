# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::CommandLine::ParseContextArgumentsTest < MatrixevalTest

  def setup
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({
      "version" => "0.1",
      "target" => "ruby",
      "matrix" => {
        "ruby" => {
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
    options = Matrixeval::Ruby::CommandLine::ParseContextArguments.call(context_arguments)
    assert_equal "3.0", options[:ruby]
    assert_nil options[:active_model]
  end

end
