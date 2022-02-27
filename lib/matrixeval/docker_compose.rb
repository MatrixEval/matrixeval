require_relative "./docker_compose/file"

module Matrixeval
  class DockerCompose

    attr_reader :context

    def initialize(context)
      @context = context
    end

    def run(arguments)
      forward_arguments = arguments.map do |arg|
        arg.match(/\s/) ? "\"#{arg}\"" : arg
      end.join(" ")

      no_tty = %w[bash sh zsh dash].include?(arguments[0]) ? '' : '--no-TTY' 

      system(
        <<~DOCKER_COMPOSE_COMMAND
        #{docker_compose} \
        run --rm \
        #{no_tty} \
        #{context.docker_compose_service_name} \
        #{forward_arguments}
        DOCKER_COMPOSE_COMMAND
      )
    ensure
      stop_containers
      clean_containers_and_anonymous_volumes
      remove_network
      turn_on_stty_opost
    end

    private

    def stop_containers
      system("#{docker_compose} stop >> /dev/null 2>&1")
    end

    def clean_containers_and_anonymous_volumes
      system("#{docker_compose} rm -v -f >> /dev/null 2>&1")
    end

    def remove_network
      system("#{docker_compose} down >> /dev/null 2>&1")
    end

    def docker_compose
      <<~DOCKER_COMPOSE_COMMAND.strip
      docker --log-level error compose \
      -f #{yaml_file} \
      -p matrixeval-#{project_name}-#{context.id}
      DOCKER_COMPOSE_COMMAND
    end

    def yaml_file
      ".matrixeval/docker-compose/#{context.id}.yml"
    end

    def turn_on_stty_opost
      system("stty opost")
    end

    def project_name
      Config.project_name.gsub(/[^A-Za-z0-9-]/,'_').downcase
    end

  end
end
