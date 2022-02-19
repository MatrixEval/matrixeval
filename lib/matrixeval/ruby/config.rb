require 'yaml'
require_relative "./vector"
require_relative "./config/yaml"
require_relative "./docker_compose/extend_raw"
require_relative "./docker_compose/extend"

module Matrixeval
  module Ruby
    class Config
      class << self

        def version
          YAML["version"]
        end

        def target
          YAML["target"]
        end

        def project_name
          name = YAML["project_name"]

          if name.nil? || name.strip.empty?
            raise Error.new('missing project_name')
          end

          name
        end

        def vectors
          @vectors = YAML["matrix"].map do |key, vector_config|
            Vector.new(key, vector_config)
          end
        end

        def main_vector
          vectors.find(&:main?)
        end

        def rest_vectors
          vectors.reject(&:main?)
        end

        def variant_combinations
          main_vector_variants.product(*rest_vector_variants_matrix)
        end

        def main_vector_variants
          main_vector.variants
        end

        def rest_vector_variants_matrix
          rest_vectors.map(&:variants)
        end

        def exclusions
          YAML["exclude"] || []
        end

        def parallel_workers
          YAML["parallel_workers"] || "number_of_processors"
        end

        def commands
          cmds = YAML["commands"] || []
          COMMANDS + cmds
        end

        def docker_compose_extend_raw
          DockerCompose::ExtendRaw.new(
            YAML["docker-compose-extend"] || {}
          )
        end

      end
    end
  end
end