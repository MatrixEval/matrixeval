module Matrixeval
  module Ruby
    class Config
      module DockerComposeFileCreatable

        def create_docker_compose_file
          create_dot_matrixeval_folder

          File.open(docker_compose_file_path, 'w+') do |file|
            file.puts docker_compose_yaml
          end
        end

        private

        def docker_compose_yaml
          yaml = {}
          yaml['version'] = "3"
          yaml['services'] = {}
          main_vector.variants.map do |variant|
            mounts = [
                  "..:/app:cached",
                  "#{variant.bundle_volume_name}:/bundle"
            ] + main_vector.mounts

            yaml['services'][variant.docker_compose_service_name] = {
              "image" => variant.image,
              "volumes" => mounts,
              "environment" => {
                "BUNDLE_PATH" => "/bundle"
              },
              "working_dir" => "/app"
            }
          end
          yaml['volumes'] = {}
          main_vector.variants.each do |variant|
            yaml['volumes'][variant.bundle_volume_name] = {
              'name' => variant.bundle_volume_name
            }
          end
          yaml.to_yaml.sub(/---\n/, "")
        end

        def docker_compose_file_path
          dot_matrixeval_folder_path.join("docker-compose.yml")
        end

        def create_dot_matrixeval_folder
          FileUtils.mkdir_p dot_matrixeval_folder_path
        end

        def dot_matrixeval_folder_path
          Pathname.new(working_dir).join(".matrixeval")
        end

        def working_dir
          self.class.working_dir
        end

      end
    end
  end
end
