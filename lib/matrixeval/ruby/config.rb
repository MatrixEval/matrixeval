require 'yaml'
require_relative "./vector"
require_relative "./config/yaml"

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

      end
    end
  end
end