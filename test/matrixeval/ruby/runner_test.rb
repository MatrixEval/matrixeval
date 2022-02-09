# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::RunnerTest < MatrixevalTest

  def setup
    Matrixeval.stubs(:working_dir).returns(dummy_gem_working_dir)

    FileUtils.rm(dummy_gem_docker_compose_file_path) rescue nil
    FileUtils.rm(dummy_gem_matrixeval_file_path) rescue nil
    FileUtils.rm(dummy_gem_working_dir.join(".gitignore")) rescue nil
    FileUtils.rm Dir.glob(dummy_gem_working_dir.join(".matrixeval/Gemfile.lock.*"))
  end

  def test_start_with_init
    refute File.exist?(dummy_gem_matrixeval_file_path)

    Matrixeval::Ruby::Runner.start(["init"])

    assert File.exist?(dummy_gem_matrixeval_file_path)
  end

  def test_start_first_time
    FileUtils.rm(dummy_gem_matrixeval_file_path) rescue nil
    Matrixeval::Ruby::DockerCompose.any_instance.expects(:system).with(<<~COMMAND
      docker compose -f .matrixeval/docker-compose.yml \
      run --rm \
       \
      -v ./.matrixeval/Gemfile.lock.ruby_3_0:/app/Gemfile.lock \
      ruby_3_0 \
      rake test
      COMMAND
    )

    Matrixeval::Ruby::Runner.start(["init"])
    Matrixeval::Ruby::Runner.start(["--ruby", "3.0", "rake", "test"])
  end

  def test_start_with_existing_config_file
    File.open(dummy_gem_matrixeval_file_path, 'w+') do |file|
      file.puts(<<~MATRIXEVAL_YAML
        version: 0.1
        target: ruby
        parallel_workers: 1
        matrix:
          ruby:
            variants:
              - key: 3.0
                image: ruby:3.0.0
                default: true
              - key: 3.1
                image: ruby:3.1.0
          rails:
            variants:
              - key: 6.0
                default: true
                env:
                  RAILS_VERSION: 6.0.0
              - key: 6.1
                env:
                  RAILS_VERSION: 6.1.0
          sidekiq:
            variants:
              - key: 5.0
                default: true
                env:
                  SIDEKIQ_VERSION: 5.0.0
              - key: 6.0
                env:
                  SIDEKIQ_VERSION: 6.0.0
        MATRIXEVAL_YAML
      )
    end

    Matrixeval::Ruby::DockerCompose.any_instance.expects(:system).with(<<~COMMAND
      docker compose -f .matrixeval/docker-compose.yml \
      run --rm \
      -e RAILS_VERSION='6.0.0' \
      -e SIDEKIQ_VERSION='5.0.0' \
      -v ./.matrixeval/Gemfile.lock.ruby_3_0_rails_6_0_sidekiq_5_0:/app/Gemfile.lock \
      ruby_3_0 \
      rake test
      COMMAND
    )
    Matrixeval::Ruby::Runner.start(["--rails", "6.0", "--sidekiq", "5.0", "rake", "test"])
  end

end