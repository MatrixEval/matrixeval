# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::Config::FileCreatableTest < MatrixevalTest

  def setup
    FileUtils.rm(dummy_gem_matrixeval_file_path) rescue nil
    Matrixeval::Ruby::Config.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_creating_dot_matrixeval_yaml
    refute File.exist?(dummy_gem_matrixeval_file_path)

    Matrixeval::Ruby::Config.create

    assert File.exist?(dummy_gem_matrixeval_file_path)
  end

  def test_not_delete_exising_dot_matrixeval_yaml
    File.open(dummy_gem_matrixeval_file_path, "w+") do |file|
      file.puts "Customizations"
    end

    Matrixeval::Ruby::Config.create

    assert_equal "Customizations\n", File.read(dummy_gem_matrixeval_file_path)
  end

end
