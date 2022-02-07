# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::VectorTest < MatrixevalTest

  def test_key
    vector = Matrixeval::Ruby::Vector.new('ruby', {})
    assert_equal "ruby", vector.key
  end

  def test_variants_with_hash
    vector = Matrixeval::Ruby::Vector.new('ruby', {"variants" => [{"key" => "3.1"}]})
    variants = vector.variants
    assert_equal 1, variants.count
    assert_equal "3.1", variants[0].key
  end

  def test_mounts
    vector = Matrixeval::Ruby::Vector.new('ruby', {"mounts" => ['/a', '/b']})
    assert_equal ['/a', '/b'], vector.mounts
  end

  def test_main
    vector = Matrixeval::Ruby::Vector.new('ruby', {})
    assert vector.main?

    vector = Matrixeval::Ruby::Vector.new('active_model', {})
    refute vector.main?
  end

  def test_id
    vector = Matrixeval::Ruby::Vector.new('ruby-3.0', {})
    assert_equal 'ruby_3_0', vector.id
  end

end
