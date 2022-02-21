# frozen_string_literal: true

require "test_helper"

class Matrixeval::CommandLine::ParseInitArgumentsTest < MatrixevalTest

  def test_call
    init_arguments = ["--target", "ruby"]
    options = Matrixeval::CommandLine::ParseInitArguments.call(init_arguments)
    assert_equal "ruby", options[:target]

    options = Matrixeval::CommandLine::ParseInitArguments.call([])
    assert options[:target].nil?
  end

end
