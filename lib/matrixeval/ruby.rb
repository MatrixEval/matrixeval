# frozen_string_literal: true

require_relative "ruby/version"
require 'rainbow'
require 'matrixeval/ruby/docker_compose'
require 'matrixeval/ruby/context'
require 'matrixeval/ruby/gemfile_locks'
require 'matrixeval/ruby/extra_mount_files'
require 'matrixeval/ruby/runner'
require 'matrixeval/ruby/gitignore'

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
