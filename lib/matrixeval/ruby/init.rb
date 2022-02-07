module Matrixeval
  module Ruby
    class Init
      class << self
        def call
          new.call
        end
      end

      def call
        create_config_yaml
      end

      private

      def create_config_yaml
        return if File.exist?(config)

        FileUtils.cp(template, config)
      end

      def template
        gem_root_path.join("lib/matrixeval/ruby/templates/matrixeval.yml")
      end

      def config
        working_dir.join("matrixeval.yml")
      end

      def working_dir
        Pathname.new(Dir.getwd)
      end

      def gem_root_path
        Matrixeval::Ruby.root
      end
    end
  end
end