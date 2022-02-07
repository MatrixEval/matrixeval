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
    end
  end
end
