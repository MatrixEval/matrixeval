require "erb"

module Matrixeval
  module Ruby
    class DockerCompose
      class YAML
        class << self

          def create
            FileUtils.mkdir_p dot_matrixeval_folder

            File.open(path, 'w+') do |file|
              file.puts build_content
            end
          end

          private

          def build_content
            {
              "version" => "3",
              "services" => services_json,
              "volumes" => volumes_json
            }.to_yaml.sub(/---\n/, "")
          end

          def services_json
            services = {}

            Config.main_vector_variants.map do |variant|
              services[variant.docker_compose_service_name] = {
                "image" => variant.image,
                "volumes" => mounts(variant),
                "environment" => {
                  "BUNDLE_PATH" => "/bundle",
                  "GEM_HOME" => "/bundle",
                  "BUNDLE_APP_CONFIG" => "/bundle",
                  "BUNDLE_BIN" => "/bundle/bin",
                  "PATH" => "/app/bin:/bundle/bin:$PATH"
                },
                "working_dir" => "/app"
              }
            end

            services
          end

          def volumes_json
            bundle_volumes.map do |volume|
              [volume, {"name" => volume}]
            end.to_h
          end

          def bundle_volumes
            Config.main_vector_variants.map(&:bundle_volume_name)
          end

          def mounts(variant)
            [
              "..:/app:cached",
              "#{variant.bundle_volume_name}:/bundle",
            ] + Config.main_vector.mounts
          end

          def path
            dot_matrixeval_folder.join("docker-compose.yml")
          end

          def dot_matrixeval_folder
            Matrixeval.working_dir.join(".matrixeval")
          end

        end
      end
    end
  end
end