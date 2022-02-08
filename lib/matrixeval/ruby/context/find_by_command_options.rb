module Matrixeval
  module Ruby
    class Context
      class FindByCommandOptions
        class << self
          def call(options)
            new(options).call
          end
        end

        attr_reader :options

        def initialize(options)
          @options = options
        end

        def call
          context = Context.all.find do |context|
            context.main_variant == main_variant &&
             context.rest_variants == rest_variants
          end

          raise Error.new("Can't find a corresponding matrix") if context.nil?

          context
        end

        private

        def main_variant
          dig_variant Config.main_vector
        end

        def rest_variants
          Config.rest_vectors.map do |vector|
            dig_variant vector
          end.sort do |v1, v2|
            v1.id <=> v2.id
          end
        end

        def dig_variant(vector)
          if option_key?(vector.key)
            find_variant(vector)
          else
            vector.default_variant
          end
        end

        def find_variant(vector)
          vector.variants.find do |variant|
            option(vector.key) == variant.key
          end
        end

        def option(key)
          options[key.to_sym] || options[key.to_s]
        end

        def option_key?(key)
          options.key?(key.to_sym) || options.key?(key.to_s)
        end

      end
    end
  end
end