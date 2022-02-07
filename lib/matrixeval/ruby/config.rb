require 'yaml'
require_relative "./vector"
require_relative "./config/file_creatable"

module Matrixeval
  module Ruby
    class Config
      extend FileCreatable

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

      def to_yaml
        yaml = {}
        yaml['version'] = "3"
        yaml['services'] = {}
        main_vector.variants.map do |variant|
          mounts = [
                "..:/app/:cached",
                "#{variant.bundle_volume_name}:/bundle"
          ] + main_vector.mounts

          yaml['services'][variant.docker_compose_service_name] = {
            "image" => variant.image,
            "volumes" => mounts,
            "environment" => {
              "BUNDLE_PATH" => "/bundle"
            },
            "working_dir" => "/app"
          }
        end
        yaml['volumes'] = {}
        main_vector.variants.each do |variant|
          yaml['volumes'][variant.bundle_volume_name] = {
            'name' => variant.bundle_volume_name
          }
        end
        yaml.to_yaml.sub(/---\n/, "")
      end

      def main_vector
        vectors.find(&:main?)
      end


    end
  end
end