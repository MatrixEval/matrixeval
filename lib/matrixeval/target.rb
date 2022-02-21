module Matrixeval
  class Target
    class << self
      def matrixeval_yml_template_path
        Matrixeval.root.join("lib/matrixeval/templates/matrixeval.yml")
      end

      def vector_key
        nil
      end
    end
  end
end
