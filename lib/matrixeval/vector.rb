module Matrixeval
  class Vector
    attr_reader :key, :variants, :main

    def initialize(key, config)
      @key = key.to_s
      @main = !!config["main"]
      @variants = (config["variants"] || []).map do |variant_config|
        _config = if variant_config.is_a?(Hash)
          variant_config
        else
          { "key" => variant_config.to_s }
        end

        Variant.new(_config, self)
      end
    end

    def main?
      return main if Config.target.vector_key.nil?

      Config.target.vector_key == key
    end

    def id
      "#{key.to_s.gsub(/[^A-Za-z0-9]/,'_')}"
    end

    def default_variant
      variant = variants.find(&:default?)
      if variant.nil?
        raise Error.new("Please set a default variant for matrix #{key}")
      end

      variant
    end
  end
end
