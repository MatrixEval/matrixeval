require_relative "./variant"

module Matrixeval
  module Ruby
    class Factor
      attr_reader :key, :variants

      def initialize(key, variants)
        @key = key
        @variants = variants.map do |variant_config|
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
