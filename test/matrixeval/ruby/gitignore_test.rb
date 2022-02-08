# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::GitignoreTest < MatrixevalTest

  def setup
    FileUtils.rm(dummy_gem_working_dir.join(".gitignore")) rescue nil
    Matrixeval.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_create
    refute File.exist?(dummy_gem_working_dir.join(".gitignore"))

    Matrixeval::Ruby::Gitignore.update

    expected_gitignore_content = <<~GITIGNORE
      .matrixeval/docker-compose.yml
      .matrixeval/Gemfile.lock.*
      GITIGNORE
    gitignore_content = File.read dummy_gem_working_dir.join(".gitignore")
    assert_equal expected_gitignore_content, gitignore_content
  end

  def test_update
    File.open(dummy_gem_working_dir.join(".gitignore"), 'w+') do |file|
      file.puts ".env"
    end

    Matrixeval::Ruby::Gitignore.update

    expected_gitignore_content = <<~GITIGNORE
      .env
      .matrixeval/docker-compose.yml
      .matrixeval/Gemfile.lock.*
      GITIGNORE
    gitignore_content = File.read dummy_gem_working_dir.join(".gitignore")
    assert_equal expected_gitignore_content, gitignore_content
  end

  def test_update_duplicate_check
    File.open(dummy_gem_working_dir.join(".gitignore"), 'w+') do |file|
      file.puts ".env"
      file.puts ".matrixeval/Gemfile.lock.*"
    end

    Matrixeval::Ruby::Gitignore.update

    expected_gitignore_content = <<~GITIGNORE
      .env
      .matrixeval/Gemfile.lock.*
      .matrixeval/docker-compose.yml
      GITIGNORE
    gitignore_content = File.read dummy_gem_working_dir.join(".gitignore")
    assert_equal expected_gitignore_content, gitignore_content
  end

end
