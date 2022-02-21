module Matrixeval
  class Gitignore
    class << self

      def update
        ignore_paths.map do |path|
          ignore(path)
        end
      end

      private

      def ignore_paths
        [docker_compose] + Config.target.gitignore_paths
      end

      def docker_compose
        ".matrixeval/docker-compose"
      end

      def ignore(path)
        return if ignored?(path)

        File.open(gitignore_path, 'a+') do |file|
          file.puts path
        end
      end

      def ignored?(path)
        File.exist?(gitignore_path) &&
          File.read(gitignore_path).include?(path)
      end

      def gitignore_path
        Matrixeval.working_dir.join(".gitignore")
      end

    end
  end
end
