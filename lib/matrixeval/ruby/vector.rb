require_relative "./variant"

module Matrixeval
  module Ruby
    class Vector
      attr_reader :key, :variants, :mounts

      def initialize(key, config)
        @key = key
        @mounts = config["mounts"] || []
        @variants = config["variants"].map do |variant_config|
          if variant_config.is_a?(Hash)
            Variant.new(variant_config, self)
          else
            Variant.default(variant_config, self)
          end
        end
      end

      def main?
        key == "ruby"
      end

      def pathname
        "#{key.to_s.gsub(/[^A-Za-z0-9]/,'_')}"
      end
    end
  end
end
