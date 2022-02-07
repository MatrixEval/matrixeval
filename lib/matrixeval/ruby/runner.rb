require 'optparse'
require 'pathname'
require 'fileutils'
require 'matrixeval/ruby/config'
require 'byebug'

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
          target_commands.include?(arg)
        end
        matrixeval_argv = ARGV[0...target_command_index]

        matrixeval_options = {}
        OptionParser.new do |opts|
          opts.banner = "Usage: meval --[VECTOR_KEY] [VECTOR_CHOICE] [COMMAND] [COMMAND_OPTIONS]"

          config.vectors.each do |vector|
            opts.on("--#{vector.key} [VERSION]", "Set #{vector.key} version") do |version|
              matrixeval_options[vector.key] = version
            end
          end
        end.parse!(matrixeval_argv, into: matrixeval_options)

        docker_compose_service_name = config.main_vector.variants.find do |variant|
          variant.key.to_s == matrixeval_options[:ruby]
        end.docker_compose_service_name

        target_variants = config.vectors.map do |vector|
          variant = vector.variants.find do |variant|
            variant.key.to_s == matrixeval_options[vector.key]
          end
        end.flatten


        env = target_variants.map do |variant|
          variant.env.map do |k, v|
            "-e #{k}=#{v}"
          end
        end.flatten.join(" ")

        gemfile_mount = "-v ./.matrixeval/Gemfile.lock.#{target_variants.map(&:pathname).join("_")}:/app/Gemfile.lock"

        docker_compose_command = <<~DOCKER_COMMAND
          docker compose -f .matrixeval/docker-compose.yml \
            run --rm \
            #{env} \
            #{gemfile_mount} \
            #{docker_compose_service_name} \
            #{ARGV[target_command_index..-1].join(" ")}
          DOCKER_COMMAND
        system(docker_compose_command)
      end

      private

      def create_gemfile_spec_locks
        main_vector_variants = config.main_vector.variants
        other_vector_variants = config.vectors.reject do |vector|
          vector.main?
        end.map(&:variants)

        main_vector_variants.product(*other_vector_variants).each do |variants| 
          FileUtils.touch Pathname.new(current_working_dir).join(".matrixeval/Gemfile.lock.#{variants.map(&:pathname).join("_")}")
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
        ['rake', 'rspec', 'bundle']
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
