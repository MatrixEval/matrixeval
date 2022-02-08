
require_relative "./docker_compose/yaml"

module Matrixeval
  module Ruby
    class DockerCompose

      attr_reader :context

      def initialize(context)
        @context = context
      end

      def run(arguments)
        forward_arguments = arguments.join(" ")
        puts Rainbow("[ MatrixEval ] ").blue.bright + Rainbow(" #{context.name} ").white.bright.bg(:blue)
        puts Rainbow("[ MatrixEval ] Run \"#{forward_arguments}\"").blue.bright

        system(
          <<~DOCKER_COMPOSE_COMMAND
          docker compose -f .matrixeval/docker-compose.yml \
          run --rm \
          #{env} \
          #{gemfile_mount} \
          #{docker_compose_service_name} \
          #{forward_arguments}
          DOCKER_COMPOSE_COMMAND
        )
      end

      private

      def env
        context.env.map do |k, v|
          "-e #{k}=#{v}"
        end.join(" ")
      end

      def gemfile_mount
        "-v ./.matrixeval/Gemfile.lock.#{context.id}:/app/Gemfile.lock"
      end

      def docker_compose_service_name
        context.docker_compose_service_name
      end

    end
  end
end