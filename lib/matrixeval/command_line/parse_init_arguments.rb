module Matrixeval
  class CommandLine
    class ParseInitArguments
      class << self
        def call(arguments)
          new(arguments).call
        end
      end

      attr_reader :init_arguments, :options

      def initialize(init_arguments)
        @init_arguments = init_arguments
        @options = {}
      end

      def call
        parse!
        options
      end

      private

      def parse!
        OptionParser.new do |opts|
          opts.version = Matrixeval::VERSION
          opts.program_name = ""
          opts.banner = <<~USAGE
            Usage:
                matrixeval(meval) init [Options]
            USAGE

          opts.separator ""
          opts.separator "Options:"
          opts.on("-t", "--target [TARGET]", *[
            "# Initialize with a specific target",
            "# Options: #{Matrixeval.targets.keys}",
            "# Default: none"
          ])

          opts.on("-h", "--help", "# Show help") do
            puts opts.help
            exit
          end
        end.parse!(init_arguments, into: options)
      end

    end
  end
end
