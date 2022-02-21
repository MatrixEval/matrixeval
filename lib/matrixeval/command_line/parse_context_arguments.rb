module Matrixeval
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
          opts.version = Config.target.version
          opts.program_name = ""
          opts.banner = <<~USAGE
            Usage:
                matrixeval(meval) [OPTIONS] COMMAND
            USAGE

          opts.separator ""
          opts.separator "Options:"

          opts.on "-a", "--all", "# Run the COMMAND against all matrix combinations"

          Config.vectors.each do |vector|
            # short = "-#{vector.short_key}"
            long = "--#{vector.key} [VERSION]"
            desc = [
              "# Run the COMMAND against a specific #{vector.key} version",
              "# Options: #{vector.variants.map(&:key).join("/")}",
              "# Default: #{vector.default_variant.key}",
              "# Customizable"
            ]
            opts.separator ""
            opts.on(long, *desc)
          end

          opts.separator ""
          opts.separator "Commands: #{Config.commands.join("/")} (Customizable)"

          opts.separator ""
          opts.separator "MatrixEval Options:"

          opts.on("-h", "--help", "# Show help") do
            puts opts.help
            exit
          end

          opts.on("-v", "--version", "# Show version") do
            puts opts.version
            exit
          end

          opts.separator ""
          opts.separator "Customizations:"
          opts.separator "    You can customize all options in matrixeval.yml"

          Config.target.cli_example_lines.each do |line|
            opts.separator line
          end

        end.parse!(context_arguments, into: options)
      end

    end
  end
end
