# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::ConfigTest < MatrixevalTest

  def setup
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({
      "version" => "0.1",
      "target" => "ruby",
      "matrix" => {
        "ruby" => {
          "variants" => [
            { "key" => "3.0" },
            { "key" => "3.1" }
          ]
        },
        "active_model" => {
          "variants" => [
            { "key" => "6.1" },
            { "key" => "7.0" }
          ]
        }
      },
      "exclude" => [
        { "ruby" => "3.0", "active_model" => "7.0" },
        { "ruby" => "3.1", "active_model" => "6.1" }
      ]
    })
  end

  def test_version
    assert_equal "0.1", Matrixeval::Ruby::Config.version
  end

  def test_target
    assert_equal "ruby", Matrixeval::Ruby::Config.target
  end

  def test_vectors
    vectors = Matrixeval::Ruby::Config.vectors
    assert_equal 2, vectors.count
    assert_equal "ruby", vectors[0].key
    assert_equal "active_model", vectors[1].key
  end

  def test_main_vector
    assert_equal "ruby", Matrixeval::Ruby::Config.main_vector.key
  end

  def test_rest_vectors
    rest_vectors = Matrixeval::Ruby::Config.rest_vectors
    assert_equal 1, rest_vectors.count
    assert_equal "active_model", rest_vectors[0].key
  end

  def test_variant_combinations
    variant_combinations = Matrixeval::Ruby::Config.variant_combinations
    assert_equal 4, variant_combinations.count
  end

  def test_main_vector_variants
    variants = Matrixeval::Ruby::Config.main_vector_variants
    assert_equal 2, variants.count
    assert_equal "3.0", variants[0].key
    assert_equal "3.1", variants[1].key
  end

  def test_rest_vector_variants_matrix
    variants_matrix = Matrixeval::Ruby::Config.rest_vector_variants_matrix
    assert_equal 1, variants_matrix.count
    assert_equal 2, variants_matrix[0].count
    assert_equal "6.1", variants_matrix[0][0].key
    assert_equal "7.0", variants_matrix[0][1].key
  end

  def test_exclusions
    exclusions = [
      { "ruby" => "3.0", "active_model" => "7.0" },
      { "ruby" => "3.1", "active_model" => "6.1" }
    ]
    assert_equal exclusions, Matrixeval::Ruby::Config.exclusions
  end

end
