# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::Config::DockerComposeFileCreatableCreatableTest < MatrixevalTest

  def setup
    FileUtils.rm(dummy_gem_docker_compose_file_path) rescue nil
    Matrixeval::Ruby::Config.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_creating_docker_compose_file
    refute File.exist?(dummy_gem_docker_compose_file_path)

    config = Matrixeval::Ruby::Config.new({
      "version" => "0.1",
      "target" => "ruby",
      "matrix" => {
        "ruby" => {
          "variants" => [
            { "key" => "3.0", "image" => "ruby:3.0.0" },
            { "key" => "3.1", "image" => "ruby:3.1.0" },
          ]
        },
        "active_model" => {
          "variants" => [
            { "key" => "6.1", "env" => { "ACTIVE_MODEL_VERSION" => "6.1.4" } },
            { "key" => "7.0", "env" => { "ACTIVE_MODEL_VERSION" => "7.0.0" } },
          ]
        }
      }
    })
    config.create_docker_compose_file

    file_content = File.read(dummy_gem_docker_compose_file_path)
    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      services:
        ruby_3_0:
          image: ruby:3.0.0
          volumes:
          - "..:/app:cached"
          - bundle_ruby_3_0_0:/bundle
          environment:
            BUNDLE_PATH: "/bundle"
          working_dir: "/app"
        ruby_3_1:
          image: ruby:3.1.0
          volumes:
          - "..:/app:cached"
          - bundle_ruby_3_1_0:/bundle
          environment:
            BUNDLE_PATH: "/bundle"
          working_dir: "/app"
      volumes:
        bundle_ruby_3_0_0:
          name: bundle_ruby_3_0_0
        bundle_ruby_3_1_0:
          name: bundle_ruby_3_1_0
      DOCKER_COMPOSE
    assert_equal expect_file_content, file_content
  end

end
