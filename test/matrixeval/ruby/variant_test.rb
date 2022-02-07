# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::VariantTest < MatrixevalTest

  def setup
    @vector = stub(id: 'ruby')
  end

  def test_key
    variant = Matrixeval::Ruby::Variant.new({"key" => 3.1}, @vector)
    assert_equal 3.1, variant.key
  end

  def test_key_missing
    assert_raises "Variant#key is missing" do
      Matrixeval::Ruby::Variant.new({}, @vector)
    end
  end
  
  def test_image
    variant = Matrixeval::Ruby::Variant.new({"key" => 3.1, "image" => "ruby:3.1.0"}, @vector)
    assert_equal 3.1, variant.key
  end

  def test_env
    variant = Matrixeval::Ruby::Variant.new({"key" => 3.1}, @vector)
    assert_equal [], variant.env
  end

  def test_vector
    variant = Matrixeval::Ruby::Variant.new({"key" => 3.1}, @vector)
    assert_equal @vector, variant.vector
  end

  def test_bundle_volume_name
    variant = Matrixeval::Ruby::Variant.new({"key" => 3.1, "image" => "ruby:3.1.0"}, @vector)
    assert_equal "bundle_ruby_3_1_0", variant.bundle_volume_name
  end

  def test_id
    variant = Matrixeval::Ruby::Variant.new({"key" => 3.1, "image" => "ruby:3.1.0"}, @vector)
    assert_equal "ruby_3_1", variant.id
  end

  def test_docker_compose_service_name
    variant = Matrixeval::Ruby::Variant.new({"key" => 3.1, "image" => "ruby:3.1.0"}, @vector)
    assert_equal "ruby_3_1", variant.docker_compose_service_name
  end

  def test_pathname
    variant = Matrixeval::Ruby::Variant.new({"key" => 3.1, "image" => "ruby:3.1.0"}, @vector)
    assert_equal "ruby_3_1", variant.pathname
  end

end
