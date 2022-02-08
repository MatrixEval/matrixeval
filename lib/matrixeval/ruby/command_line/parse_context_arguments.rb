module Matrixeval
  module Ruby
    class CommandLine
      class ParseContextArguments
        class << self
          def call(context_arguments)
            new(context_arguments).call
          end
        end

        attr_reader :context_arguments, :options

        def initialize(context_arguments)
          @context_arguments = context_arguments 
          @options = {}
        end

        def call
          parse!
          options
        end

        private

        def parse!
          OptionParser.new do |opts|
            opts.banner = "Usage: meval/matrixeval --[VECTOR_KEY] [VECTOR_CHOICE] [COMMAND] [COMMAND_OPTIONS]"

            Config.vectors.each do |vector|
              opts.on("--#{vector.key} [VERSION]", "Set #{vector.key} version")
            end
          end.parse!(context_arguments, into: options)
        end

      end
    end
  end
end