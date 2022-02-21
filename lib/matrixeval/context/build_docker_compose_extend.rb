require 'erb'
require 'json'

module Matrixeval
  class Context
    class BuildDockerComposeExtend
      class << self
        def call(context)
          new(context).call
        end
      end

      attr_reader :context

      def initialize(context)
        @context = context
      end

      def matrix_combination_id
        context.id
      end

      def call
        DockerCompose::Extend.new(docker_compose_extend)
      end

      private

      def docker_compose_extend
        JSON.parse(render_erb)
      end

      def render_erb
        ERB.new(
          Config.docker_compose_extend_raw.content
        ).result(binding)
      end

    end
  end
end
