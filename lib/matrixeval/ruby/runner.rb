require 'optparse'
require 'pathname'
require 'fileutils'
require 'matrixeval/config'

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
        create_dot_matrixeval_folder
        create_matrixeval_context
        create_docker_compose_yaml
        create_gemfile_spec_locks

        target_command_index = argv.index do |arg|
          arg.in?(target_commands)
        end
        matrixeval_argv = ARGV[0...target_command_index]
        # matrixeval_options = {}
        # OptionParser.new do |opts|
        #   opts.banner = "Usage: example.rb [options]"

        #   config.factors.each do |factor|
        #     opts.on("--#{factor.key}", "Set #{factor.key} version") do |v|
        #       # options[:verbose] = v
        #     end
        #   end
        # end.parse!(into: matrixeval_options)
      end

      private

      def create_gemfile_spec_locks
        config.main_factor.variants.each do |variant|
          FileUtils.touch Pathname.new(current_working_dir).join(".matrixeval/#{variant.gemfile_lock_file_name}")
        end
      end

      def create_dot_matrixeval_folder
        FileUtils.mkdir_p dot_matrixeval_folder_path
      end

      def create_matrixeval_context
        return if File.exist?(matrixeval_context_path)

        FileUtils.touch(matrixeval_context_path)
      end

      def create_docker_compose_yaml
        # if File.exist?(docker_compose_yaml_path)
        #   FileUtils.rm(docker_compose_yaml_path)
        # end

        File.open(docker_compose_yaml_path, 'w+') do |file|
          # file.puts({'a' => 1, 'b' => [{'a' => 2}]}.to_yaml.sub("---\n", ''))
          file.puts(config.to_yaml)
        end
      end

      def docker_compose_yaml_path
        Pathname.new(current_working_dir).join(".matrixeval/docker-compose.yml")
      end

      def matrixeval_context_path
        Pathname.new(current_working_dir).join(".matrixeval/context.yml")
      end

      def dot_matrixeval_folder_path
        Pathname.new(current_working_dir).join(".matrixeval")
      end

      def target_commands
        ['rake', 'rspec']
      end

      def config
        @config ||= Config.parse(config_path)
      end

      def config_path
        Pathname.new(current_working_dir).join("matrixeval.yml").to_s
      end

      def current_working_dir
        @current_working_dir ||= Dir.getwd
      end
    end
  end
end
