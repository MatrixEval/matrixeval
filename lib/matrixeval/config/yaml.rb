require 'yaml'

module Matrixeval
  class Config
    class YAML

      class MissingError < StandardError; end

      class << self

        def create_for(target_name)
          return if File.exist?(path)

          FileUtils.cp(
            target(target_name).matrixeval_yml_template_path,
            path
          )
        end

        def path
          Matrixeval.working_dir.join("matrixeval.yml")
        end

        def [](key)
          yaml[key]
        end

        def yaml
          raise MissingError unless File.exist?(path)

          ::YAML.load File.read(path)
        end

        private

        def target(target_name)
          Matrixeval.targets[target_name] || Target
        end

      end
    end
  end
end
