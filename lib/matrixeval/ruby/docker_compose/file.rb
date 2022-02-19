require "erb"

module Matrixeval
  module Ruby
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
            "networks" => { network => nil },
            "services" => services_json,
            "volumes" => volumes_json
          }.to_yaml.sub(/---\n/, "")
        end

        def network
          "matrixeval-#{context.id}"
        end

        def services_json
          services = {}

          services[main_variant.docker_compose_service_name] = {
            "image" => main_variant.container.image,
            "volumes" => mounts(main_variant),
            "environment" => {
              "BUNDLE_PATH" => "/bundle",
              "GEM_HOME" => "/bundle",
              "BUNDLE_APP_CONFIG" => "/bundle",
              "BUNDLE_BIN" => "/bundle/bin",
              "PATH" => "/app/bin:/bundle/bin:$PATH"
            }.merge(context.env).merge(main_variant.container.env),
            "working_dir" => "/app",
            "networks" => [network],
          }.merge(depends_on)

          services.merge(extra_services)
        end

        def volumes_json
          {
            bundle_volume => {
              "name" => bundle_volume
            }
          }.merge(docker_compose_extend.volumes)
        end

        def depends_on
          if docker_compose_extend.services.keys.empty?
            {}
          else
            { "depends_on" => docker_compose_extend.services.keys }
          end
        end

        def extra_services
          docker_compose_extend.services.map do |name, config|
            [name, config.merge({'networks' => [network]})]
          end.to_h
        end

        def main_variant
          context.main_variant
        end

        def bundle_volume
          main_variant.bundle_volume_name
        end

        def mounts(variant)
          [
            "../..:/app:cached",
            "#{variant.bundle_volume_name}:/bundle",
            "../Gemfile.lock.#{context.id}:/app/Gemfile.lock"
          ] + Config.main_vector.mounts
        end

        def docker_compose_extend
          @docker_compose_extend ||= context.docker_compose_extend
        end

        def working_dir_name
          Matrixeval.working_dir.basename
        end

        def project_name
          Config.project_name.gsub(/[^A-Za-z0-9]/,'_').downcase
        end

      end
    end
  end
end