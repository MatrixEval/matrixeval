require 'yaml'

module Matrixeval
  class Config
    class YAML

      class MissingError < StandardError; end

      class << self

        def create
          return if File.exist?(path)

          FileUtils.cp(template_path, path)
        end

        def template_path
          Config.target.matrixeval_yml_template_path
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

      end
    end
  end
end
