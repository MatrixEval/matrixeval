require_relative "./variant"

module Matrixeval
  module Ruby
    class Vector
      attr_reader :key, :variants, :mounts

      def initialize(key, config)
        @key = key
        @mounts = config["mounts"] || []
        @variants = (config["variants"] || []).map do |variant_config|
          config = if variant_config.is_a?(Hash)
            variant_config
          else
            { "key" => variant_config }
          end

          Variant.new(config, self)
        end
      end

      def main?
        key == "ruby"
      end

      def id
        "#{key.to_s.gsub(/[^A-Za-z0-9]/,'_')}"
      end

      def default_variant
        variant = variants.find(&:default?)
        if variant.nil?
          raise Error.new("Please set a default variant for matrix #{vector.key}")
        end

        variant
      end
    end
  end
end
