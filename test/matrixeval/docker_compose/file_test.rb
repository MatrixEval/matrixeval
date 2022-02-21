# frozen_string_literal: true

require "test_helper"

class Matrixeval::DockerCompose::FileTest < MatrixevalTest

  def setup
    FileUtils.rm_rf(dummy_gem_docker_compose_folder_path) rescue nil
    Matrixeval.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_create_all
    refute File.exist?(dummy_gem_docker_compose_folder_path)

    Matrixeval::Config::YAML.stubs(:yaml).returns({
      "version" => "0.3",
      "project_name" => "Dummy_gem",
      "mounts" => ["/a/b:/app/c/d"],
      "env" => {
        "DATABASE_HOST" => "postgres"
      },
      "matrix" => {
        "ruby" => {
          "main" => true,
          "variants" => [
            { "key" => "3.0", "container" => { "image" => "ruby:3.0.0" }, "default" => true },
            { "key" => "3.1", "container" => { "image" => "ruby:3.1.0" } }
          ]
        },
        "active_model" => {
          "variants" => [
            {
              "key" => "6.1",
              "env" => { "ACTIVE_MODEL_VERSION" => "6.1.4" },
              "default" => true,
              "mounts" => [
                ".matrixeval/schema/rails_6_1.rb:/app/test/dummy/db/schema.rb"
              ]
            },
            {
              "key" => "7.0",
              "env" => { "ACTIVE_MODEL_VERSION" => "7.0.0" },
              "mounts" => [
                ".matrixeval/schema/rails_7_0.rb:/app/test/dummy/db/schema.rb"
              ]
            }
          ]
        }
      },
      "docker-compose-extend" => {
        "services" => {
          "postgres" => {
            "image" => "postgres:12.8",
            "volumes" => [
              "postgres12:/var/lib/postgresql/data"
            ],
            "environment" => {
              "POSTGRES_HOST_AUTH_METHOD" => "trust"
            }
          }
        },
        "volumes" => {
          "postgres12" => nil
        }
      }
    })
    Matrixeval::DockerCompose::File.create_all

    file_content = File.read(dummy_gem_docker_compose_folder_path.join("ruby_3_0_active_model_6_1.yml"))

    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      services:
        ruby_3_0:
          image: ruby:3.0.0
          volumes:
          - "../..:/app:cached"
          - "/a/b:/app/c/d"
          - "../schema/rails_6_1.rb:/app/test/dummy/db/schema.rb"
          environment:
            DATABASE_HOST: postgres
            ACTIVE_MODEL_VERSION: 6.1.4
          working_dir: "/app"
          depends_on:
          - postgres
        postgres:
          image: postgres:12.8
          volumes:
          - postgres12:/var/lib/postgresql/data
          environment:
            POSTGRES_HOST_AUTH_METHOD: trust
      volumes:
        postgres12:
      DOCKER_COMPOSE
    assert_equal expect_file_content.strip, file_content.strip

    file_content = File.read(dummy_gem_docker_compose_folder_path.join("ruby_3_0_active_model_7_0.yml"))
    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      services:
        ruby_3_0:
          image: ruby:3.0.0
          volumes:
          - "../..:/app:cached"
          - "/a/b:/app/c/d"
          - "../schema/rails_7_0.rb:/app/test/dummy/db/schema.rb"
          environment:
            DATABASE_HOST: postgres
            ACTIVE_MODEL_VERSION: 7.0.0
          working_dir: "/app"
          depends_on:
          - postgres
        postgres:
          image: postgres:12.8
          volumes:
          - postgres12:/var/lib/postgresql/data
          environment:
            POSTGRES_HOST_AUTH_METHOD: trust
      volumes:
        postgres12:
      DOCKER_COMPOSE
    assert_equal expect_file_content.strip, file_content.strip

    file_content = File.read(dummy_gem_docker_compose_folder_path.join("ruby_3_1_active_model_6_1.yml"))
    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      services:
        ruby_3_1:
          image: ruby:3.1.0
          volumes:
          - "../..:/app:cached"
          - "/a/b:/app/c/d"
          - "../schema/rails_6_1.rb:/app/test/dummy/db/schema.rb"
          environment:
            DATABASE_HOST: postgres
            ACTIVE_MODEL_VERSION: 6.1.4
          working_dir: "/app"
          depends_on:
          - postgres
        postgres:
          image: postgres:12.8
          volumes:
          - postgres12:/var/lib/postgresql/data
          environment:
            POSTGRES_HOST_AUTH_METHOD: trust
      volumes:
        postgres12:
      DOCKER_COMPOSE
    assert_equal expect_file_content.strip, file_content.strip

    file_content = File.read(dummy_gem_docker_compose_folder_path.join("ruby_3_1_active_model_7_0.yml"))
    expect_file_content = <<~DOCKER_COMPOSE
      version: '3'
      services:
        ruby_3_1:
          image: ruby:3.1.0
          volumes:
          - "../..:/app:cached"
          - "/a/b:/app/c/d"
          - "../schema/rails_7_0.rb:/app/test/dummy/db/schema.rb"
          environment:
            DATABASE_HOST: postgres
            ACTIVE_MODEL_VERSION: 7.0.0
          working_dir: "/app"
          depends_on:
          - postgres
        postgres:
          image: postgres:12.8
          volumes:
          - postgres12:/var/lib/postgresql/data
          environment:
            POSTGRES_HOST_AUTH_METHOD: trust
      volumes:
        postgres12:
      DOCKER_COMPOSE
    assert_equal expect_file_content.strip, file_content.strip
  end


end
