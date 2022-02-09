require_relative "./command_line/parse_context_arguments"

module Matrixeval
  module Ruby
    class CommandLine

      attr_reader :argv

      def initialize(argv)
        @argv = argv
      end

      def init?
        argv[0] == 'init'
      end

      def all?
        argv[0] == 'all'
      end

      def context_options
        ParseContextArguments.call(context_arguments)
      end

      def context_arguments
        argv[0...seperator_index]
      end

      def rest_arguments
        argv[seperator_index..-1]
      end

      private

      def seperator_index
        argv.index do |argument|
          seperator_commands.include?(argument)
        end
      end

      def seperator_commands
        ['rake', 'rspec', 'bundle']
      end

    end
  end
end