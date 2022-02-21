module Matrixeval
  class DockerCompose
    class ExtendRaw

      def initialize(config)
        @config = config || {}
      end

      def content
        @config.to_json
      end

    end
  end
end
