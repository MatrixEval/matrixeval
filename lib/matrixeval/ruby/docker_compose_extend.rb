require 'json'

module Matrixeval
  module Ruby
    class DockerComposeExtend

      def initialize(config)
        @config = config || {}
      end

      def raw
        @config.to_json
      end

    end
  end
end
