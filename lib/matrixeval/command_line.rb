require_relative "./command_line/parse_context_arguments"

module Matrixeval

  COMMANDS = ['bash', 'dash', 'sh', 'zsh']

  class CommandLine

    attr_reader :argv

    def initialize(argv)
      @argv = argv
    end

    def valid?
      init? ||
        !context_options.empty? ||
        !seperator_index.nil?
    end

    def init?
      @argv[0] == 'init'
    end

    def all?
      context_options[:all]
    end

    def context_options
      @context_options ||= ParseContextArguments.call(context_arguments)
    end

    def context_arguments
      arguments = @argv[0...seperator_index]
      arguments << "-h" if @argv.empty?
      arguments
    end

    def rest_arguments
      @argv[seperator_index..-1]
    end

    private

    def seperator_index
      @argv.index do |argument|
        Config.commands.include?(argument)
      end
    end

  end
end
