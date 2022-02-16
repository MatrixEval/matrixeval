# frozen_string_literal: true

require 'test_helper'

class Matrixeval::Ruby::DockerCompose::ExtendRawTest < MatrixevalTest

  def setup
    @extend_raw = Matrixeval::Ruby::DockerCompose::ExtendRaw.new({
      "volumes" => {
        "postgres12-<%= matrix_combination_id %>" => nil
      }
    })
    # @docker_compose_extend = Matrixeval::Ruby::DockerCompose::ExtendRaw.new({
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

  def test_content
    assert_equal "{\"volumes\":{\"postgres12-<%= matrix_combination_id %>\":null}}", @extend_raw.content
  end

end
