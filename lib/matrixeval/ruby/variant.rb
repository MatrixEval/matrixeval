require_relative "./container"

module Matrixeval
  module Ruby
    class Variant
      class << self
        def default(key, vector)
          self.new({"key" => key}, vector)
        end
      end

      attr_reader :key, :env, :vector, :default, :container

      def initialize(config = {}, vector)
        raise Error.new("Variant#key is missing") if config["key"].nil?

        @vector = vector
        @key = config["key"].to_s
        @container = Container.new(config["container"])
        @env = config["env"] || {}
        @default = config["default"] || false
      end

      def name
        "#{vector.key}: #{key}"
      end

      def bundle_volume_name
        "bundle_#{container.image.gsub(/[^A-Za-z0-9]/,'_')}"
      end

      def id
        "#{vector.id}_#{key.to_s.gsub(/[^A-Za-z0-9]/,'_')}"
      end

      def docker_compose_service_name
        id
      end

      def pathname
        id
      end

      def default?
        default
      end

      def match_command_options?(options)
        options[vector.key] == key.to_s
      end

      def ==(variant)
        vector.key == variant.vector.key &&
          key == variant.key
      end
    end
  end
end
