require 'yaml'
require_relative "./factor"

module Matrixeval
  module Ruby
    class Config
      class << self
        def parse(path)
          yaml = YAML.load(File.read(path))
          new(yaml)
        end
      end

      attr_reader :yaml, :version, :target, :factors

      def initialize(yaml)
        @yaml = yaml
        @version = yaml["version"]
        @target = yaml["target"]
        @factors = yaml["matrix"].map do |key, factor_config|
          Factor.new(key, factor_config)
        end
      end

      def to_yaml
        yaml = {}
        yaml['version'] = "3"
        yaml['services'] = {}
        main_factor.variants.map do |variant|
          mounts = [
                "..:/app/:cached",
                "#{variant.bundle_volume_name}:/bundle"
          ] + main_factor.mounts

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
        main_factor.variants.each do |variant|
          yaml['volumes'][variant.bundle_volume_name] = {
            'name' => variant.bundle_volume_name
          }
        end
        yaml.to_yaml.sub(/---\n/, "")
      end

      def main_factor
        factors.find(&:main?)
      end


    end
  end
end