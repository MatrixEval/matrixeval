require_relative "./context/find_by_command_options"
require_relative "./context/build_docker_compose_extend"

module Matrixeval
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
        end.select do |context|
          Config.exclusions.none? do |exclusion|
            context.match_exclusion?(exclusion)
          end
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

    def name
      variants.map(&:name).join(", ")
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

    def docker_compose_file_path
      Matrixeval.working_dir.join(".matrixeval/docker-compose/#{id}.yml")
    end

    def variants
      [main_variant] + rest_variants
    end

    def match_exclusion?(exclusion)
      return false if exclusion.empty?

      variants.all? do |variant|
        vector_key = variant.vector.key
        if exclusion.key?(vector_key)
          exclusion[vector_key].to_s == variant.key
        else
          true
        end
      end
    end

    def docker_compose_extend
      BuildDockerComposeExtend.call(self)
    end

  end
end
