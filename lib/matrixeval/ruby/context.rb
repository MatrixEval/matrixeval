require_relative "./context/find_by_command_options"

module Matrixeval
  module Ruby
    class Context

      class << self

        def find_by_command_options!(options)
          FindByCommandOptions.call(options)
        end

        def all
          Config.variant_combinations.map do |variants|
            Context.new(
              main_variant:  variants.find { |v| v.vector.main? },
              rest_variants: variants.reject { |v| v.vector.main? }
            )
          end
        end

      end

      attr_reader :main_variant, :rest_variants

      def initialize(main_variant:, rest_variants:)
        @main_variant = main_variant
        @rest_variants = (rest_variants || []).sort do |v1, v2|
          v1.id <=> v2.id
        end
      end

      def id
        [[main_variant.id] + rest_variants.map(&:id)].join("_")
      end

      def env
        rest_variants.map(&:env).reduce({}, &:merge)
          .merge(main_variant.env)
      end

      def docker_compose_service_name
        main_variant.id
      end

      def gemfile_lock_path
        Matrixeval.working_dir.join(".matrixeval/Gemfile.lock.#{id}")
      end

      def variants
        [main_variant] + rest_variants
      end

    end
  end
end
