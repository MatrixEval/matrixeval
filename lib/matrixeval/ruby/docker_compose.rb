
require_relative "./docker_compose/yaml"
require_relative "./docker_compose/file"

module Matrixeval
  module Ruby
    class DockerCompose

      attr_reader :context

      def initialize(context)
        @context = context
      end

      def run(arguments)
        forward_arguments = arguments.join(" ")

        system(
          <<~DOCKER_COMPOSE_COMMAND
          docker compose -f #{yaml_file} \
          run --rm \
          #{context.docker_compose_service_name} \
          #{forward_arguments}
          DOCKER_COMPOSE_COMMAND
        )
      ensure
        turn_on_stty_opost
        clean_linked_containers
      end

      private

      def clean_linked_containers
        system("docker compose -f #{yaml_file} down >> /dev/null 2>&1")
      end

      def yaml_file
        ".matrixeval/docker-compose/#{context.id}.yml"
      end

      def turn_on_stty_opost
        system("stty opost")
      end

    end
  end
end