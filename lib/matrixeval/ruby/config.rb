require 'yaml'
require_relative "./vector"
require_relative "./config/yaml"

module Matrixeval
  module Ruby
    class Config
      class << self

        def yaml
          @yaml ||= YAML.parse
        end

        def version
          yaml["version"]
        end

        def target
          yaml["target"]
        end

        def vectors
          @vectors = yaml["matrix"].map do |key, vector_config|
            Vector.new(key, vector_config)
          end
        end

        def main_vector
          @main_vector ||= vectors.find(&:main?)
        end

        def rest_vectors
          @rest_vectors ||= vectors.reject(&:main?)
        end

        def variant_combinations
          @variant_combinations ||= main_vector_variants.product(*rest_vector_variants_matrix)
        end

        def main_vector_variants
          main_vector.variants
        end

        def rest_vector_variants_matrix
          rest_vectors.map(&:variants)
        end

      end
    end
  end
end