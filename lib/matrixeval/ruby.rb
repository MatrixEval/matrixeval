# frozen_string_literal: true

require_relative "ruby/version"
require 'matrixeval/ruby/runner'

module Matrixeval
  module Ruby
    class Error < StandardError; end

    module_function
    def root
      Pathname.new("#{__dir__}/../..")
    end
  end

  module_function
  def start(argv)
    Ruby::Runner.start(argv)
  end

  def working_dir
    Pathname.new(Dir.getwd)
  end
end
