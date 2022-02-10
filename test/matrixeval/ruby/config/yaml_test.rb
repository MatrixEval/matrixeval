# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::Config::YAMLTest < MatrixevalTest

  def setup
    FileUtils.rm(dummy_gem_matrixeval_file_path) rescue nil
    Matrixeval.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_creating_dot_matrixeval_yaml
    refute File.exist?(dummy_gem_matrixeval_file_path)

    Matrixeval::Ruby::Config::YAML.create

    assert File.exist?(dummy_gem_matrixeval_file_path)
  end

  def test_not_delete_exising_dot_matrixeval_yaml
    File.open(dummy_gem_matrixeval_file_path, "w+") do |file|
      file.puts "Customizations"
    end

    Matrixeval::Ruby::Config::YAML.create

    assert_equal "Customizations\n", File.read(dummy_gem_matrixeval_file_path)
  end

  def test_square_brackets
    yaml_content = {
      "version" => "0.2",
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
      }
    }
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns(yaml_content)
    assert_equal "0.2", Matrixeval::Ruby::Config::YAML["version"]
    assert_equal "ruby", Matrixeval::Ruby::Config::YAML["target"]
    assert_equal "3.0", Matrixeval::Ruby::Config::YAML["matrix"]["ruby"]["variants"][0]["key"]
    assert_equal "3.1", Matrixeval::Ruby::Config::YAML["matrix"]["ruby"]["variants"][1]["key"]
    assert_equal "6.1", Matrixeval::Ruby::Config::YAML["matrix"]["active_model"]["variants"][0]["key"]
    assert_equal "7.0", Matrixeval::Ruby::Config::YAML["matrix"]["active_model"]["variants"][1]["key"]
  end

end
