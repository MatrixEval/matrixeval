module Matrixeval
  class Target
    class << self

      def version
        Matrixeval::VERSION
      end

      def matrixeval_yml_template_path
        Matrixeval.root.join("lib/matrixeval/templates/matrixeval.yml")
      end

      def vector_key
        nil
      end

      def env(context)
        {}
      end

      def mounts(context)
        []
      end

      def volumes(context)
        {}
      end

      def gitignore_paths
        []
      end

      def support_commands
        []
      end

      def cli_example_lines
        []
      end

    end
  end
end
