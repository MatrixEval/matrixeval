module Matrixeval
  module Ruby
    class DockerCompose
      class Extend

        def initialize(config)
          @config = config || {}
        end

        def volumes
          @config["volumes"] || {}
        end

        def services
          @config["services"] || {}
        end

      end
    end
  end
end
