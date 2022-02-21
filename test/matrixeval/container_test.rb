require 'test_helper'

class Matrixeval::ContainerTest < MatrixevalTest

  def container(config)
    Matrixeval::Container.new(config)
  end

  def test_image
    assert_equal "ruby:3.0.1", container("image" => "ruby:3.0.1").image
  end

  def test_image_default
    assert container({}).image.nil?
  end

  def test_env
    assert_equal({"RAILS_ENV" => "7.0.1"}, container("env" => {"RAILS_ENV" => "7.0.1"}).env)
  end

  def test_env_default
    assert_equal({}, container({}).env)
  end

end
