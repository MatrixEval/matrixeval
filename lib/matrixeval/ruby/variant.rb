module Matrixeval
  module Ruby
    class Variant
      class << self
        def default(key)
          self.new({"key" => key})
        end
      end

      attr_reader :key, :image, :bundle_path

      def initialize(config = {})
        @key = config["key"]
        @image = config["image"]
        @bundle_path = config["bundle_path"]
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

      def gemfile_lock_file_name
        "Gemfile.lock.ruby_#{key.to_s.gsub(/[^A-Za-z0-9]/,'_')}"
      end
    end
  end
end
