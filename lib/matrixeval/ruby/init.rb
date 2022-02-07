module Matrixeval
  module Ruby
    class Init

      class << self
        def call
          new.call
        end
      end

      def call
        Config.create
      end

    end
  end
end