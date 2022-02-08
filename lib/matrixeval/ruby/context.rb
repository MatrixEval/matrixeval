module Matrixeval
  module Ruby
    class Context

      attr_reader :main_variant, :rest_variants

      def initialize(main_variant:, rest_variants:)
        @main_variant = main_variant
        @rest_variants = (rest_variants || []).sort do |v1, v2|
          v1.id <=> v2.id
        end
      end

      def id
        "#{main_variant.id}_#{rest_variants.map(&:id).join("_")}"
      end

      def env
        main_variant.env + rest_variants.map(&:env).flatten
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
