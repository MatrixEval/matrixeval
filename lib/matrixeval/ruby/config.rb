require 'yaml'
require_relative "./vector"
require_relative "./config/yaml"
require_relative "./config/file_creatable"
require_relative "./config/docker_compose_file_creatable"

module Matrixeval
  module Ruby
    class Config
      extend FileCreatable
      include DockerComposeFileCreatable

      class << self
        def parse(path)
          yaml = YAML.load(File.read(path))
          new(yaml)
        end
      end

      attr_reader :yaml, :version, :target, :vectors

      def initialize(yaml)
        @yaml = yaml
        @version = yaml["version"]
        @target = yaml["target"]
        @vectors = yaml["matrix"].map do |key, vector_config|
          Vector.new(key, vector_config)
        end
      end

      def main_vector
        vectors.find(&:main?)
      end


    end
  end
end