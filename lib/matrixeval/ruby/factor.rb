require_relative "./variant"

module Matrixeval
  module Ruby
    class Factor
      attr_reader :key, :variants, :mounts

      def initialize(key, config)
        @key = key
        @mounts = config["mounts"] || []
        @variants = config["variants"].map do |variant_config|
          if variant_config.is_a?(Hash)
            Variant.new(variant_config)
          else
            Variant.default(variant_config)
          end
        end
      end

      def main?
        key == "ruby"
      end
    end
  end
end
