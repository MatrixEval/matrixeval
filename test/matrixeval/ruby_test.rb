# frozen_string_literal: true

require "test_helper"

class Matrixeval::RubyTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Matrixeval::Ruby::VERSION
  end

  def test_root
    assert_match /matrixeval-ruby\/lib\/matrixeval\/\.\.\/\.\.$/, Matrixeval::Ruby.root.to_s
  end
end
