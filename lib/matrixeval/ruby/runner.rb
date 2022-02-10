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
      attr_accessor :threads, :matrixeval_results

      def initialize(argv)
        @argv = argv
        @command = CommandLine.new(argv)
        @threads ||= []
        @matrixeval_results ||= []
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

        pull_all_images

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
        parallel(contexts) do |sub_contexts|
          Thread.current[:matrixeval_results] = []

          sub_contexts.each do |context|
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

      def pull_all_images
        parallel(Config.main_vector_variants) do |sub_variants|
          sub_variants.each do |variant|
            puts "Docker image check/pull #{variant.container.image}"
            image_exists = system %Q{[ -n "$(docker images -q #{variant.container.image})" ]}
            next if image_exists

            system "docker pull #{variant.container.image}"
          end
        end
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

      def parallel(collection)
        threads = [] unless threads.empty?
        matrixeval_results = [] unless matrixeval_results.empty?

        collection.each_slice(per_worker_contexts_count) do |sub_collection|
          threads << Thread.new do
            yield sub_collection
          end
        end

        threads.each(&:join)

        threads.each do |thread|
          self.matrixeval_results += (thread[:matrixeval_results] || [])
        end
      end


      def per_worker_contexts_count
        [(contexts.count / workers_count), 1].max
      end

      def contexts
        @contexts ||= Context.all
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
