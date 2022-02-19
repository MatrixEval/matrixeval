# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::DockerCompose::FileTest < MatrixevalTest

  def setup
    FileUtils.rm_rf(dummy_gem_docker_compose_folder_path) rescue nil
    Matrixeval.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_create_all
    refute File.exist?(dummy_gem_docker_compose_folder_path)

    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({
      "version" => "0.2",
      "target" => "ruby",
      "project_name" => "Dummy_gem",
      "matrix" => {
        "ruby" => {
          "variants" => [
            { "key" => "3.0", "container" => { "image" => "ruby:3.0.0" }, "default" => true },
            { "key" => "3.1", "container" => { "image" => "ruby:3.1.0" } }
          ]
        },
        "active_model" => {
          "variants" => [
            { "key" => "6.1", "env" => { "ACTIVE_MODEL_VERSION" => "6.1.4" }, "default" => true },
            { "key" => "7.0", "env" => { "ACTIVE_MODEL_VERSION" => "7.0.0" } }
          ]
        }
      },
      "docker-compose-extend" => {
        "services" => {
          "postgres" => {
            "image" => "postgres:12.8",
            "volumes" => [
              "postgres12-<%= matrix_combination_id %>:/var/lib/postgresql/data"
            ],
            "environment" => {
              "POSTGRES_HOST_AUTH_METHOD" => "trust"
            }
          }
        },
        "volumes" => {
          "postgres12-<%= matrix_combination_id %>" => nil
        }
      }
    })
    Matrixeval::Ruby::DockerCompose::File.create_all

    file_content = File.read(dummy_gem_docker_compose_folder_path.join("ruby_3_0_active_model_6_1.yml"))

    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      networks:
        matrixeval-ruby_3_0_active_model_6_1:
      services:
        ruby_3_0:
          image: ruby:3.0.0
          volumes:
          - "../..:/app:cached"
          - bundle_ruby_3_0_0:/bundle
          - "../Gemfile.lock.ruby_3_0_active_model_6_1:/app/Gemfile.lock"
          environment:
            BUNDLE_PATH: "/bundle"
            GEM_HOME: "/bundle"
            BUNDLE_APP_CONFIG: "/bundle"
            BUNDLE_BIN: "/bundle/bin"
            PATH: "/app/bin:/bundle/bin:$PATH"
            ACTIVE_MODEL_VERSION: 6.1.4
          working_dir: "/app"
          networks:
          - matrixeval-ruby_3_0_active_model_6_1
          depends_on:
          - postgres
        postgres:
          image: postgres:12.8
          volumes:
          - postgres12-ruby_3_0_active_model_6_1:/var/lib/postgresql/data
          environment:
            POSTGRES_HOST_AUTH_METHOD: trust
          networks:
          - matrixeval-ruby_3_0_active_model_6_1
      volumes:
        bundle_ruby_3_0_0:
          name: bundle_ruby_3_0_0
        postgres12-ruby_3_0_active_model_6_1:
      DOCKER_COMPOSE
    assert_equal expect_file_content, file_content

    file_content = File.read(dummy_gem_docker_compose_folder_path.join("ruby_3_0_active_model_7_0.yml"))
    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      networks:
        matrixeval-ruby_3_0_active_model_7_0:
      services:
        ruby_3_0:
          image: ruby:3.0.0
          volumes:
          - "../..:/app:cached"
          - bundle_ruby_3_0_0:/bundle
          - "../Gemfile.lock.ruby_3_0_active_model_7_0:/app/Gemfile.lock"
          environment:
            BUNDLE_PATH: "/bundle"
            GEM_HOME: "/bundle"
            BUNDLE_APP_CONFIG: "/bundle"
            BUNDLE_BIN: "/bundle/bin"
            PATH: "/app/bin:/bundle/bin:$PATH"
            ACTIVE_MODEL_VERSION: 7.0.0
          working_dir: "/app"
          networks:
          - matrixeval-ruby_3_0_active_model_7_0
          depends_on:
          - postgres
        postgres:
          image: postgres:12.8
          volumes:
          - postgres12-ruby_3_0_active_model_7_0:/var/lib/postgresql/data
          environment:
            POSTGRES_HOST_AUTH_METHOD: trust
          networks:
          - matrixeval-ruby_3_0_active_model_7_0
      volumes:
        bundle_ruby_3_0_0:
          name: bundle_ruby_3_0_0
        postgres12-ruby_3_0_active_model_7_0:
      DOCKER_COMPOSE
    assert_equal expect_file_content, file_content

    file_content = File.read(dummy_gem_docker_compose_folder_path.join("ruby_3_1_active_model_6_1.yml"))
    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      networks:
        matrixeval-ruby_3_1_active_model_6_1:
      services:
        ruby_3_1:
          image: ruby:3.1.0
          volumes:
          - "../..:/app:cached"
          - bundle_ruby_3_1_0:/bundle
          - "../Gemfile.lock.ruby_3_1_active_model_6_1:/app/Gemfile.lock"
          environment:
            BUNDLE_PATH: "/bundle"
            GEM_HOME: "/bundle"
            BUNDLE_APP_CONFIG: "/bundle"
            BUNDLE_BIN: "/bundle/bin"
            PATH: "/app/bin:/bundle/bin:$PATH"
            ACTIVE_MODEL_VERSION: 6.1.4
          working_dir: "/app"
          networks:
          - matrixeval-ruby_3_1_active_model_6_1
          depends_on:
          - postgres
        postgres:
          image: postgres:12.8
          volumes:
          - postgres12-ruby_3_1_active_model_6_1:/var/lib/postgresql/data
          environment:
            POSTGRES_HOST_AUTH_METHOD: trust
          networks:
          - matrixeval-ruby_3_1_active_model_6_1
      volumes:
        bundle_ruby_3_1_0:
          name: bundle_ruby_3_1_0
        postgres12-ruby_3_1_active_model_6_1:
      DOCKER_COMPOSE
    assert_equal expect_file_content, file_content

    file_content = File.read(dummy_gem_docker_compose_folder_path.join("ruby_3_1_active_model_7_0.yml"))
    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      networks:
        matrixeval-ruby_3_1_active_model_7_0:
      services:
        ruby_3_1:
          image: ruby:3.1.0
          volumes:
          - "../..:/app:cached"
          - bundle_ruby_3_1_0:/bundle
          - "../Gemfile.lock.ruby_3_1_active_model_7_0:/app/Gemfile.lock"
          environment:
            BUNDLE_PATH: "/bundle"
            GEM_HOME: "/bundle"
            BUNDLE_APP_CONFIG: "/bundle"
            BUNDLE_BIN: "/bundle/bin"
            PATH: "/app/bin:/bundle/bin:$PATH"
            ACTIVE_MODEL_VERSION: 7.0.0
          working_dir: "/app"
          networks:
          - matrixeval-ruby_3_1_active_model_7_0
          depends_on:
          - postgres
        postgres:
          image: postgres:12.8
          volumes:
          - postgres12-ruby_3_1_active_model_7_0:/var/lib/postgresql/data
          environment:
            POSTGRES_HOST_AUTH_METHOD: trust
          networks:
          - matrixeval-ruby_3_1_active_model_7_0
      volumes:
        bundle_ruby_3_1_0:
          name: bundle_ruby_3_1_0
        postgres12-ruby_3_1_active_model_7_0:
      DOCKER_COMPOSE
    assert_equal expect_file_content, file_content
  end


end
