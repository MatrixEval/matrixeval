# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::InitTest < MatrixevalTest

  def test_call_config_create
    Matrixeval::Ruby::Config.expects(:create)

    Matrixeval::Ruby::Init.call
  end

end
