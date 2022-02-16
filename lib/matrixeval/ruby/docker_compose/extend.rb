module Matrixeval
  module Ruby
    class DockerCompose
      class Extend

        def initialize(config)
          @config = config || {}
        end

        def volumes
          @config["volumes"] || []
        end

      end
    end
  end
end
