module Matrixeval
  class Target
    class << self
      def matrixeval_yml_template_path
        Matrixeval.root.join("lib/matrixeval/templates/matrixeval.yml")
      end
    end
  end
end
