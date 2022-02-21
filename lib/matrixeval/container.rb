module Matrixeval
  class Container

    attr_reader :image, :env

    def initialize(options)
      options ||= {}
      @image = options["image"]
      @env = options["env"] || {}
    end

  end
end
