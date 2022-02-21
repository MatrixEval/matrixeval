# frozen_string_literal: true

require "test_helper"

class Matrixeval::CommandLineTest < MatrixevalTest

  def setup
    Matrixeval::Config::YAML.stubs(:yaml).returns({"matrix" => {}})
  end

  def test_commands
    assert_equal ['bash', 'dash', 'sh', 'zsh'], Matrixeval::COMMANDS
  end

  def test_init?
    command = Matrixeval::CommandLine.new(["init"])
    assert command.init?

    command = Matrixeval::CommandLine.new(["bash"])
    refute command.init?
  end

  def test_all?
    command = Matrixeval::CommandLine.new(["--all", "rake", "test"])
    assert command.all?

    command = Matrixeval::CommandLine.new(["-a", "rake", "test"])
    assert command.all?

    command = Matrixeval::CommandLine.new(["rake", "test"])
    refute command.all?
  end

  def test_context_arguments
    command = Matrixeval::CommandLine.new([
      "--ruby", "3.0",
      "--active_model", "7.0.0",
      "bash"
    ])
    assert_equal ["--ruby", "3.0", "--active_model", "7.0.0"], command.context_arguments
  end

  def test_rest_arguments
    command = Matrixeval::CommandLine.new([
      "--ruby", "3.0",
      "--active_model", "7.0.0",
      "bash"
    ])
    assert_equal ["bash"], command.rest_arguments
  end

  def test_context_options
    Matrixeval::CommandLine::ParseContextArguments.expects(:call).with(["--ruby", "3.0"]).returns({ruby: "3.0"})

    command = Matrixeval::CommandLine.new([
      "--ruby", "3.0",
      "bash"
    ])
    assert_equal({ruby: "3.0"}, command.context_options)
  end

end
