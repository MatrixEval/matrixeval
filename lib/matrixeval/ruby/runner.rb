require 'optparse'
require 'pathname'
require 'fileutils'
require 'matrixeval/ruby/config'
require 'matrixeval/ruby/command_line'
require "concurrent/utility/processor_counter"
require 'terminal-table'

module Matrixeval
  module Ruby
    class Runner
      class << self
        def start(argv)
          new(argv).start
        end
      end

      attr_reader :argv, :command

      def initialize(argv)
        @argv = argv
        @command = CommandLine.new(argv)
      end

      def start
        validates

        if command.init?
          init
        elsif command.all?
          run_all_contexts
        else
          run_a_specific_context
        end
      rescue OptionParser::InvalidOption => e
        puts <<~ERROR
          #{e.message}
          See 'matrixeval --help'
          ERROR
        exit
      rescue Config::YAML::MissingError
        puts "Please run 'matrixeval init' first to generate matrixeval.yml"
        exit
      ensure
        turn_on_stty_opost
      end

      private

      def validates
        return if command.valid?

        puts <<~ERROR
          matrixeval: '#{argv.join(' ')}' is not a MatrixEval command.
          See 'matrixeval --help'
          ERROR
        exit
      end

      def init
        Config::YAML.create
        Gitignore.update
      end

      def run_all_contexts
        Config::YAML.create
        DockerCompose::YAML.create
        GemfileLocks.create
        Gitignore.update

        if workers_count == 1
          run_all_contexts_sequentially
        else
          run_all_contexts_in_parallel
        end
      end

      def run_all_contexts_sequentially
        Context.all.each do |context|
          puts Rainbow("[ MatrixEval ] ").blue.bright + Rainbow(" #{context.name} ").white.bright.bg(:blue)
          puts Rainbow("[ MatrixEval ] Run \"#{command.rest_arguments.join(" ")}\"").blue.bright

          docker_compose = DockerCompose.new(context)
          success = docker_compose.run(command.rest_arguments)

          self.matrixeval_results << [context, !!success]
        end

        report
      end

      def run_all_contexts_in_parallel
        parallel do |contexts|
          Thread.current[:matrixeval_results] = []

          contexts.each do |context|
            docker_compose = DockerCompose.new(context)
            success = docker_compose.run(command.rest_arguments)

            Thread.current[:matrixeval_results] << [context, !!success]
          end
        end

        report
      end

      def run_a_specific_context
        Config::YAML.create
        DockerCompose::YAML.create
        GemfileLocks.create
        Gitignore.update

        context = Context.find_by_command_options!(command.context_options)

        puts Rainbow("[ MatrixEval ] ").blue.bright + Rainbow(" #{context.name} ").white.bright.bg(:blue)
        puts Rainbow("[ MatrixEval ] Run \"#{command.rest_arguments.join(" ")}\"").blue.bright

        docker_compose = DockerCompose.new(context)
        docker_compose.run(command.rest_arguments)
      end

      def report
        turn_on_stty_opost

        table = Terminal::Table.new(title: Rainbow("MatrixEval").blue.bright + " Summary", alignment: :center) do |table|

          headers = Config.vectors.map(&:key) + ['result']
          table.add_row headers.map { |value| { value: value, alignment: :center } }
          table.add_separator 

          matrixeval_results.each do |context, success|
            success_cell = [success ? Rainbow('Success').green : Rainbow('Failed').red]
            row = (context.variants.map(&:key) + success_cell).map do |value|
              { value: value, alignment: :center }
            end

            table.add_row row
          end

        end

        puts table
      end

      def parallel
        contexts = Context.all

        contexts.each_slice(contexts.count / workers_count) do |sub_contexts|
          threads << Thread.new do
            yield sub_contexts
          end
        end

        threads.each(&:join)

        threads.each do |thread|
          self.matrixeval_results += thread[:matrixeval_results]
        end
      end

      def threads
        @threads ||= []
      end

      def matrixeval_results
        @matrixeval_results ||= []
      end

      def matrixeval_results=(results)
        @matrixeval_results = results
      end

      def workers_count
        count = if Config.parallel_workers == "number_of_processors"
          Concurrent.physical_processor_count
        else
          Integer(Config.parallel_workers)
        end

        [count, 1].max
      end

      def turn_on_stty_opost
        system("stty opost")
      end

    end
  end
end
