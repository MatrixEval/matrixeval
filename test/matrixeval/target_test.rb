require 'test_helper'

class Matrixeval::TargetTest < MatrixevalTest

  def test_matrixeval_yml_template_path
    assert_equal working_dir.join("lib/../lib/matrixeval/templates/matrixeval.yml"), Matrixeval::Target.matrixeval_yml_template_path
  end

end
