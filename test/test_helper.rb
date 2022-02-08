# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "matrixeval/ruby"

require "minitest/autorun"
require "minitest/focus"
require "mocha/minitest"
require "support/path_helper"
require "byebug"

class MatrixevalTest < Minitest::Test
  include MatrixevalTestSupport::PathHelper
end