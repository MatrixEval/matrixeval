module Matrixeval
  module Ruby
    class Config
      class YAML
        class << self

          def create
            return if File.exist?(path)

            FileUtils.cp(template_path, path)
          end

          def template_path
            Matrixeval::Ruby.root.join(
              "lib/matrixeval/ruby/templates/matrixeval.yml"
            )
          end

          def path
            Matrixeval.working_dir.join("matrixeval.yml")
          end

          def parse
            ::YAML.load File.read(path)
          end

        end
      end
    end
  end
end