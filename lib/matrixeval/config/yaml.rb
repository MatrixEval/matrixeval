require 'yaml'

module Matrixeval
  class Config
    class YAML

      class MissingError < StandardError; end
      class MissingTargetGem < StandardError; end

      class << self

        def create_for(target_name)
          return if File.exist?(path)
          require "matrixeval/#{target_name}" unless target_name.nil?

          FileUtils.cp(
            target(target_name).matrixeval_yml_template_path,
            path
          )
        rescue LoadError
          raise MissingTargetGem.new("Missing gem for the target #{target_name}")
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
          target_klass(target_name).new
        end

        def target_klass(target_name)
          Matrixeval.targets[target_name&.to_sym] || Target
        end

      end
    end
  end
end
