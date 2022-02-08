# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::CommandLineTest < MatrixevalTest

  def test_init?
    command = Matrixeval::Ruby::CommandLine.new(["init"])
    assert command.init?

    command = Matrixeval::Ruby::CommandLine.new(["rake", "test"])
    refute command.init?
  end

  def test_context_arguments
    command = Matrixeval::Ruby::CommandLine.new([
      "--ruby", "3.0",
      "--active_model", "7.0.0",
      "rake", "test"
    ])
    assert_equal ["--ruby", "3.0", "--active_model", "7.0.0"], command.context_arguments
  end

  def test_rest_arguments
    command = Matrixeval::Ruby::CommandLine.new([
      "--ruby", "3.0",
      "--active_model", "7.0.0",
      "rake", "test"
    ])
    assert_equal ["rake", "test"], command.rest_arguments
  end

  def test_context_options
    Matrixeval::Ruby::CommandLine::ParseContextArguments.expects(:call).with(["--ruby", "3.0"]).returns({ruby: "3.0"})

    command = Matrixeval::Ruby::CommandLine.new([
      "--ruby", "3.0",
      "rake", "test"
    ])
    assert_equal({ruby: "3.0"}, command.context_options)
  end

end
