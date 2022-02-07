module Matrixeval
  module Ruby
    class Variant
      class << self
        def default(key, vector)
          self.new({"key" => key}, vector)
        end
      end

      attr_reader :key, :image, :bundle_path, :env, :vector

      def initialize(config = {}, vector)
        @vector = vector
        @key = config["key"]
        @image = config["image"]
        @bundle_path = config["bundle_path"]
        @env = config["env"] || []
      end

      def image
        @image ||= "ruby:#{key}"
      end

      def bundle_volume_name
        "bundle_#{image.gsub(/[^A-Za-z0-9]/,'_')}"
      end

      def docker_compose_service_name
        "ruby_#{key.to_s.gsub(/[^A-Za-z0-9]/,'_')}"
      end

      def pathname
        "#{vector.pathname}_#{key.to_s.gsub(/[^A-Za-z0-9]/,'_')}"
      end
    end
  end
end
