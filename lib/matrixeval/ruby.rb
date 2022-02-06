# frozen_string_literal: true

require_relative "ruby/version"
require 'matrixeval/ruby/runner'

module Matrixeval
  module Ruby
    class Error < StandardError; end
  end

  module_function
  def start(argv)
    Ruby::Runner.start(argv)
  end
end
