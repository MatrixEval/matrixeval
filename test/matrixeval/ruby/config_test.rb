# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::ConfigTest < MatrixevalTest

  def setup
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({
      "version" => "0.3",
      "target" => "ruby",
      "project_name" => "sample app",
      "mounts" => ["/a:/b"],
      "matrix" => {
        "ruby" => {
          "variants" => [
            { "key" => "3.0" },
            { "key" => "3.1" }
          ]
        },
        "active_model" => {
          "variants" => [
            { "key" => "6.1", "mounts" => [".matrixeval/schema/rails_6_1.rb:/app/test/dummy/db/schema.rb"] },
            { "key" => "7.0", "mounts" => [".matrixeval/schema/rails_7_0.rb:/app/test/dummy/db/schema.rb"] }
          ]
        }
      },
      "exclude" => [
        { "ruby" => "3.0", "active_model" => "7.0" },
        { "ruby" => "3.1", "active_model" => "6.1" }
      ],
      "docker-compose-extend" => {
        "volumes" => {
          "postgres12-<%= matrix_combination_id %>" => nil
        }
      }
    })
  end

  def test_version
    assert_equal "0.3", Matrixeval::Ruby::Config.version
  end

  def test_target
    assert_equal "ruby", Matrixeval::Ruby::Config.target
  end

  def test_project_name
    assert_equal "sample app", Matrixeval::Ruby::Config.project_name
  end

  def test_env
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({"env" => { 'A' => 'a' }})
    assert_equal({'A' => 'a'}, Matrixeval::Ruby::Config.env)
  end

  def test_env_default
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({})
    assert_equal({}, Matrixeval::Ruby::Config.env)
  end

  def test_mounts
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({"mounts" => ["/a:/b"]})
    assert_equal ["/a:/b"], Matrixeval::Ruby::Config.mounts
  end

  def test_mounts_default
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({})
    assert_equal [], Matrixeval::Ruby::Config.mounts
  end

  def test_all_mounts
    assert_equal([
      "/a:/b",
      ".matrixeval/schema/rails_6_1.rb:/app/test/dummy/db/schema.rb",
      ".matrixeval/schema/rails_7_0.rb:/app/test/dummy/db/schema.rb"
    ], Matrixeval::Ruby::Config.all_mounts)
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

  def test_commands
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({})
    assert_equal([
      'ruby', 'rake', 'rails', 'rspec', 'bundle',
      'bin/rake', 'bin/rails', 'bin/rspec', 'bin/test',
      'bash', 'dash', 'sh', 'zsh'
    ], Matrixeval::Ruby::Config.commands)

    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({'commands' => ['ls']})
    assert_equal([
      'ruby', 'rake', 'rails', 'rspec', 'bundle',
      'bin/rake', 'bin/rails', 'bin/rspec', 'bin/test',
      'bash', 'dash', 'sh', 'zsh',
      'ls'
    ], Matrixeval::Ruby::Config.commands)
  end

  def test_docker_compose_extend_raw
    extend_raw = Matrixeval::Ruby::Config.docker_compose_extend_raw
    assert extend_raw.is_a?(Matrixeval::Ruby::DockerCompose::ExtendRaw)

    assert_equal "{\"volumes\":{\"postgres12-<%= matrix_combination_id %>\":null}}", extend_raw.content
  end

end
