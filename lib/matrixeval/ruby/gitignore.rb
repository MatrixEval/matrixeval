module Matrixeval
  module Ruby
    class Gitignore
      class << self

        def update
          add_docker_compose
          add_gemfile_locks
        end

        private

        def add_docker_compose
          return if docker_compose_included?

          File.open(gitignore_path, 'a+') do |file|
            file.puts docker_compose
          end
        end

        def add_gemfile_locks
          return if gemfile_locks_included?

          File.open(gitignore_path, 'a+') do |file|
            file.puts gemfile_locks
          end
        end

        def docker_compose_included?
          File.exist?(gitignore_path) &&
            File.read(gitignore_path).include?(docker_compose)
        end

        def gemfile_locks_included?
          File.exist?(gitignore_path) &&
            File.read(gitignore_path).include?(gemfile_locks)
        end

        def docker_compose
          ".matrixeval/docker-compose"
        end

        def gemfile_locks
          ".matrixeval/gemfile_locks"
        end

        def gitignore_path
          Matrixeval.working_dir.join(".gitignore")
        end

      end
    end
  end
end