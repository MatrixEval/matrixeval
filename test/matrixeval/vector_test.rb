# frozen_string_literal: true

require "test_helper"

class Matrixeval::VectorTest < MatrixevalTest

  def test_key
    vector = Matrixeval::Vector.new('ruby', {})
    assert_equal "ruby", vector.key
  end

  def test_variants_with_hash
    vector = Matrixeval::Vector.new('ruby', {"variants" => [{"key" => "3.1"}]})
    variants = vector.variants
    assert_equal 1, variants.count
    assert_equal "3.1", variants[0].key
  end

  def test_main
    Matrixeval::Config.stubs(:target).returns(Matrixeval::Target.new)

    vector = Matrixeval::Vector.new('ruby', {})
    refute vector.main?

    vector = Matrixeval::Vector.new('ruby', {"main" => true})
    assert vector.main?
  end

  def test_id
    vector = Matrixeval::Vector.new('ruby-3.0', {})
    assert_equal 'ruby_3_0', vector.id
  end

  def test_default_variant
    vector = Matrixeval::Vector.new('ruby', {"variants" => [{"key" => "3.0", "default" => true}, { "key" => "3.1" }]})
    variant = vector.default_variant
    assert_equal "ruby", variant.vector.key
    assert_equal "3.0", variant.key
  end

  def test_default_variant_on_missing_default
    assert_raises "Please set a default variant for matrix ruby" do
      config = {"variants" => [{"key" => "3.0"}, { "key" => "3.1" }]}
      Matrixeval::Vector.new('ruby', config).default_variant
    end
  end

end
