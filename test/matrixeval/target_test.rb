require 'test_helper'

class Matrixeval::TargetTest < MatrixevalTest

  def setup
    @target = Matrixeval::Target.new
  end

  def test_version
    assert_equal Matrixeval::VERSION, @target.version
  end

  def test_matrixeval_yml_template_path
    assert_equal working_dir.join("lib/../lib/matrixeval/templates/matrixeval.yml"), @target.matrixeval_yml_template_path
  end

  def test_vector_key
    assert @target.vector_key.nil?
  end

  def test_env
    context = Minitest::Mock.new
    assert_equal({}, @target.env(context))
  end

  def test_mounts
    context = Minitest::Mock.new
    assert_equal([], @target.mounts(context))
  end

  def test_volumes
    context = Minitest::Mock.new
    assert_equal({}, @target.volumes(context))
  end

  def test_gitignore_paths
    assert_equal [], @target.gitignore_paths
  end

  def test_support_commands
    assert_equal [], @target.support_commands
  end

  def test_cli_example_lines
    assert_equal [], @target.cli_example_lines
  end

end
