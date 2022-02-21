# frozen_string_literal: true

require "test_helper"

class Matrixeval::Config::YAMLTest < MatrixevalTest

  def setup
    FileUtils.rm(dummy_gem_matrixeval_file_path) rescue nil
    Matrixeval.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_creating_dot_matrixeval_yaml
    refute File.exist?(dummy_gem_matrixeval_file_path)

    Matrixeval::Config::YAML.create_for(nil)

    assert File.exist?(dummy_gem_matrixeval_file_path)
  end

  def test_not_delete_exising_dot_matrixeval_yaml
    File.open(dummy_gem_matrixeval_file_path, "w+") do |file|
      file.puts "Customizations"
    end

    Matrixeval::Config::YAML.create_for(nil)

    assert_equal "Customizations\n", File.read(dummy_gem_matrixeval_file_path)
  end

  def test_square_brackets
    yaml_content = {
      "version" => "0.3",
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
    Matrixeval::Config::YAML.stubs(:yaml).returns(yaml_content)
    assert_equal "0.3", Matrixeval::Config::YAML["version"]
    assert_equal "ruby", Matrixeval::Config::YAML["target"]
    assert_equal "3.0", Matrixeval::Config::YAML["matrix"]["ruby"]["variants"][0]["key"]
    assert_equal "3.1", Matrixeval::Config::YAML["matrix"]["ruby"]["variants"][1]["key"]
    assert_equal "6.1", Matrixeval::Config::YAML["matrix"]["active_model"]["variants"][0]["key"]
    assert_equal "7.0", Matrixeval::Config::YAML["matrix"]["active_model"]["variants"][1]["key"]
  end

  def test_template_path
    File.open(dummy_gem_matrixeval_file_path, "w+") { |file| file.puts "content" }
    expected_path = File.expand_path working_dir.join("lib/matrixeval/templates/matrixeval.yml")
    actaul_path = File.expand_path Matrixeval::Target.matrixeval_yml_template_path
    assert_equal expected_path, actaul_path
  end

end
