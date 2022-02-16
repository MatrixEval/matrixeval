# frozen_string_literal: true

require 'test_helper'

class Matrixeval::Ruby::DockerComposeExtendTest < MatrixevalTest

  def setup
    @docker_compose_extend = Matrixeval::Ruby::DockerComposeExtend.new({
      "volumes" => {
        "postgres12-<%= matrix_combination_id %>" => nil
      }
    })
    # @docker_compose_extend = Matrixeval::Ruby::DockerComposeExtend.new({
    #   'services' => [
    #     {
    #       "postgres" => {
    #         "image" => "postgres:12.8",
    #         "volumes" => [
    #           "postgres12-<%= matrix_combination_id %>:/var/lib/postgresql/data"
    #         ],
    #         "environment" => [
    #           "POSTGRES_HOST_AUTH_METHOD" => 'trust'
    #         ]
    #       }
    #     },
    #     {
    #       "redis" => {
    #         "image" => "redis:6.2-alpine"
    #       }
    #     }
    #   ],
    #   "volumes" => {
    #     "postgres12-<%= matrix_combination_id %>" => nil
    #   }
    # })
  end

  def test_raw
    raw = "{\"volumes\":{\"postgres12-<%= matrix_combination_id %>\":null}}"
    assert_equal raw, @docker_compose_extend.raw
  end

end
