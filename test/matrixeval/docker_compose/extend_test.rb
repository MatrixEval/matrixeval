# frozen_string_literal: true

require 'test_helper'

class Matrixeval::DockerCompose::ExtendTest < MatrixevalTest

  def setup
    @compose_extend = Matrixeval::DockerCompose::Extend.new(
      {
        "volumes" => {
          "postgres12-ruby_3_1_rails_6_0" => nil
        }
      }
    )
  end

  def test_volumes
    assert_equal({ "postgres12-ruby_3_1_rails_6_0" => nil }, @compose_extend.volumes)
  end

  def test_services
    assert_equal({}, @compose_extend.services)
  end

end
