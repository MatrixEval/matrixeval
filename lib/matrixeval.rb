# frozen_string_literal: true

require_relative "matrixeval/version"
require 'rainbow'
require 'matrixeval/docker_compose'
require 'matrixeval/context'
require 'matrixeval/extra_mount_files'
require 'matrixeval/runner'
require 'matrixeval/gitignore'

module Matrixeval

  module_function
  def start(argv)
    Ruby::Runner.start(argv)
  end

  def working_dir
    Pathname.new(Dir.getwd)
  end

end
