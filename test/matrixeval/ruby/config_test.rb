# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::ConfigTest < MatrixevalTest

  def setup
    @config = Matrixeval::Ruby::Config.new({
      "version" => "0.1",
      "target" => "ruby",
      "matrix" => {
        "ruby" => {},
        "active_model" => {}
      }
    })
  end

  def test_yaml
    yaml_content = {
      "version" => "0.1",
      "target" => "ruby",
      "matrix" => {
        "ruby" => {},
        "active_model" => {}
      }
    }
    assert_equal yaml_content, @config.yaml
  end

  def test_version
    assert_equal "0.1", @config.version
  end

  def test_target
    assert_equal "ruby", @config.target
  end

  def test_vectors
    assert_equal 2, @config.vectors.count
    assert_equal "ruby", @config.vectors[0].key
    assert_equal "active_model", @config.vectors[1].key
  end

  def main_vector
    assert_equal "ruby", @config.main_vector.key
  end

end
