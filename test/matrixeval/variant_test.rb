# frozen_string_literal: true

require "test_helper"

class Matrixeval::VariantTest < MatrixevalTest

  def setup
    @vector = stub(id: 'ruby', key: 'ruby')
  end

  def test_key
    variant = Matrixeval::Variant.new({"key" => 3.1}, @vector)
    assert_equal "3.1", variant.key
  end

  def test_key_missing
    assert_raises "Variant#key is missing" do
      Matrixeval::Variant.new({}, @vector)
    end
  end
  
  def test_container
    variant = Matrixeval::Variant.new({"key" => 3.1, "container" => { "image" => "ruby:3.1.0"} }, @vector)
    assert variant.container.is_a?(Matrixeval::Container)
    assert_equal "ruby:3.1.0", variant.container.image
  end

  def test_env
    variant = Matrixeval::Variant.new({"key" => 3.1, "env" => { 'A' => 'a' }}, @vector)
    assert_equal({'A' => 'a'}, variant.env)
  end

  def test_env_default
    variant = Matrixeval::Variant.new({"key" => 3.1}, @vector)
    assert_equal({}, variant.env)
  end

  def test_mounts
    variant = Matrixeval::Variant.new({"key" => 3.1, "mounts" => [".matrixeval/schema/rails_6.1.rb:/app/db/schema.rb"]}, @vector)
    assert_equal([".matrixeval/schema/rails_6.1.rb:/app/db/schema.rb"], variant.mounts)
  end

  def test_mounts_default
    variant = Matrixeval::Variant.new({"key" => 3.1}, @vector)
    assert_equal([], variant.mounts)
  end

  def test_vector
    variant = Matrixeval::Variant.new({"key" => 3.1}, @vector)
    assert_equal @vector, variant.vector
  end

  def test_id
    variant = Matrixeval::Variant.new({"key" => 3.1, "container" => { "image" => "ruby:3.1.0"} }, @vector)
    assert_equal "ruby_3_1", variant.id
  end

  def test_docker_compose_service_name
    variant = Matrixeval::Variant.new({"key" => 3.1, "container" => { "image" => "ruby:3.1.0"} }, @vector)
    assert_equal "ruby_3_1", variant.docker_compose_service_name
  end

  def test_pathname
    variant = Matrixeval::Variant.new({"key" => 3.1, "container" => { "image" => "ruby:3.1.0"} }, @vector)
    assert_equal "ruby_3_1", variant.pathname
  end

  def test_default
    variant = Matrixeval::Variant.new({"key" => 3.1}, @vector)
    assert_equal false, variant.default?

    variant = Matrixeval::Variant.new({"key" => 3.1, "default" => true}, @vector)
    assert_equal true, variant.default?
  end

  def test_match_command_options
    variant = Matrixeval::Variant.new({"key" => 3.1, "default" => true}, @vector)
    assert variant.match_command_options?({"ruby" => '3.1'})
    refute variant.match_command_options?({"ruby" => '3.0'})
  end

  def test_equal
    v1 = Matrixeval::Variant.new(
      {"key" => 3.1},
      Matrixeval::Vector.new('ruby', {})
    )
    v2 = Matrixeval::Variant.new(
      {"key" => 3.1},
      Matrixeval::Vector.new('ruby', {})
    )
    assert v1 == v2
  end

  def test_equal_with_array
    v1 = Matrixeval::Variant.new(
      {"key" => 3.1},
      Matrixeval::Vector.new('ruby', {})
    )
    v2 = Matrixeval::Variant.new(
      {"key" => 3.1},
      Matrixeval::Vector.new('ruby', {})
    )
    v3 = Matrixeval::Variant.new(
      {"key" => 7.0},
      Matrixeval::Vector.new('rails', {})
    )
    v4 = Matrixeval::Variant.new(
      {"key" => 7.0},
      Matrixeval::Vector.new('rails', {})
    )
    assert [v1, v3] == [v2, v4]
  end

end
