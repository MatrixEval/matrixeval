module Matrixeval
  module Ruby
    class Variant
      class << self
        def default(key, vector)
          self.new({"key" => key}, vector)
        end
      end

      attr_reader :key, :image, :env, :vector, :default

      def initialize(config = {}, vector)
        @vector = vector
        @key = config["key"].to_s
        @image = config["image"]
        @env = config["env"] || {}
        @default = config["default"] || false

        raise Error.new("Variant#key is missing") if @key.nil?
      end

      def bundle_volume_name
        "bundle_#{image.gsub(/[^A-Za-z0-9]/,'_')}"
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
