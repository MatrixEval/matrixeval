
require_relative "./docker_compose/yaml"

module Matrixeval
  module Ruby
    class DockerCompose

      class << self
        def clean_containers
          system("docker compose -f .matrixeval/docker-compose.yml rm --all -f >> /dev/null 2>&1")
        end
      end

      attr_reader :context

      def initialize(context)
        @context = context
      end

      def run(arguments)
        forward_arguments = arguments.join(" ")

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
          "-e #{k}='#{v}'"
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