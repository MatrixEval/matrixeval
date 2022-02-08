require 'optparse'
require 'pathname'
require 'fileutils'
require 'matrixeval/ruby/config'
require 'matrixeval/ruby/command_line'

module Matrixeval
  module Ruby
    class Runner
      class << self
        def start(argv)
          new(argv).start
        end
      end

      attr_reader :argv

      def initialize(argv)
        @argv = argv
      end

      def start
        command = CommandLine.new(argv)
        if command.init?
          Config::YAML.create
        else
          Config::YAML.create
          DockerCompose::YAML.create
          GemfileLocks.create

          context = Context.find_by_command_options!(command.context_options)

          docker_compose = DockerCompose.new(context)
          docker_compose.run(command.rest_arguments)
        end
      end

    end
  end
end
