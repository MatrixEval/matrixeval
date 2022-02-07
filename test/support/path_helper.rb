class MatrixevalTestSupport
  module PathHelper

    def working_dir
      Pathname.new(Dir.getwd)
    end

    def dummy_gem_working_dir
      working_dir.join("test/dummy_gem")
    end

    def dummy_gem_matrixeval_file_path
      dummy_gem_working_dir.join("matrixeval.yml")
    end

  end
end