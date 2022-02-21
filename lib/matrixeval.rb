# frozen_string_literal: true

require_relative "matrixeval/version"

require 'pathname'
require 'fileutils'
require 'optparse'

require 'matrixeval/docker_compose/extend_raw'
require 'matrixeval/docker_compose/extend'
require 'matrixeval/container'
require 'matrixeval/variant'
require 'matrixeval/vector'
require 'matrixeval/config'

require 'matrixeval/target'

require 'matrixeval/context'
require 'matrixeval/extra_mount_files'
require 'matrixeval/docker_compose'
require 'matrixeval/gitignore'

require 'matrixeval/command_line'
require 'matrixeval/runner'

module Matrixeval

  class Error < StandardError; end

  module_function
  def start(argv)
    Runner.start(argv)
  end

  def register_target(target_name, target_klass)
    targets[target_name] = target_klass
  end

  def targets
    @targets ||= {}
  end

  def working_dir
    Pathname.new(Dir.getwd)
  end

  def root
    Pathname.new("#{__dir__}/..")
  end

end
