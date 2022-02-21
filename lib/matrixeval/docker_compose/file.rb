module Matrixeval
  class DockerCompose
    class File
      class << self

        def create_all
          FileUtils.mkdir_p folder

          Context.all.each do |context|
            new(context).create
          end
        end

        private

        def folder
          Matrixeval.working_dir.join(".matrixeval/docker-compose")
        end
      end

      attr_reader :context

      def initialize(context)
        @context = context
      end

      def create
        ::File.open(docker_compose_file_path, 'w+') do |file|
          file.puts build_content
        end
      end

      private

      def docker_compose_file_path
        context.docker_compose_file_path
      end

      def build_content
        {
          "version" => "3",
          "services" => services_json,
          "volumes" => volumes_json
        }.to_yaml.sub(/---\n/, "")
      end

      def services_json
        services = {}

        services[main_variant.docker_compose_service_name] = {
          "image" => main_variant.container.image,
          "volumes" => mounts,
          "environment" => env,
          "working_dir" => "/app"
        }.merge(depends_on)

        services.merge(docker_compose_extend.services)
      end

      def volumes_json
        target.volumes(context).merge(
          docker_compose_extend.volumes
        )
      end

      def env
        target.env(context).merge(
          Config.env,
          main_variant.container.env,
          context.env
        )
      end

      def depends_on
        if docker_compose_extend.services.keys.empty?
          {}
        else
          { "depends_on" => docker_compose_extend.services.keys }
        end
      end

      def main_variant
        context.main_variant
      end

      def mounts
        ["../..:/app:cached"] + target.mounts(context) + extra_mounts
      end

      def extra_mounts
        mounts = Config.mounts + context.variants.map(&:mounts).flatten
        mounts.map do |mount|
          local_path, in_docker_path = mount.split(':')
          next mount if Pathname.new(local_path).absolute?

          local_path = Matrixeval.working_dir.join(local_path)
          docker_compose_folder_path = Matrixeval.working_dir.join(".matrixeval/docker-compose")
          local_path = local_path.relative_path_from docker_compose_folder_path

          "#{local_path}:#{in_docker_path}"
        end
      end

      def docker_compose_extend
        @docker_compose_extend ||= context.docker_compose_extend
      end

      def working_dir_name
        Matrixeval.working_dir.basename
      end

      def project_name
        Config.project_name.gsub(/[^A-Za-z0-9-]/,'_').downcase
      end

      def target
        Config.target
      end

    end
  end
end
