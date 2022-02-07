module Matrixeval
  module Ruby
    class Config
      module FileCreatable

        def create
          return if File.exist?(path)

          FileUtils.cp(template_path, path)
        end

        private

        def template_path
          Matrixeval::Ruby.root.join(
            "lib/matrixeval/ruby/templates/matrixeval.yml"
          )
        end

        def path
          working_dir.join("matrixeval.yml")
        end

        def working_dir
          Pathname.new(Dir.getwd)
        end

      end
    end
  end
end