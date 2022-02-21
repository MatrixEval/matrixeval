require 'test_helper'

class Matrixeval::TargetTest < MatrixevalTest

  def test_version
    assert_equal Matrixeval::VERSION, Matrixeval::Target.version
  end

  def test_matrixeval_yml_template_path
    assert_equal working_dir.join("lib/../lib/matrixeval/templates/matrixeval.yml"), Matrixeval::Target.matrixeval_yml_template_path
  end

  def test_vector_key
    assert Matrixeval::Target.vector_key.nil?
  end

  def test_env
    context = Minitest::Mock.new
    assert_equal({}, Matrixeval::Target.env(context))
  end

  def test_mounts
    context = Minitest::Mock.new
    assert_equal([], Matrixeval::Target.mounts(context))
  end

  def test_volumes
    context = Minitest::Mock.new
    assert_equal({}, Matrixeval::Target.volumes(context))
  end

  def test_gitignore_paths
    assert_equal [], Matrixeval::Target.gitignore_paths
  end

  def test_support_commands
    assert_equal [], Matrixeval::Target.support_commands
  end

  def test_cli_example_lines
    assert_equal [], Matrixeval::Target.cli_example_lines
  end

end
