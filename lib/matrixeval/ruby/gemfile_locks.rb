module Matrixeval
  module Ruby
    class GemfileLocks
      class << self

        def create
          FileUtils.mkdir_p dot_matrixeval_folder

          Context.all.each do |context|
            FileUtils.touch context.gemfile_lock_path
          end
        end

        private

        def dot_matrixeval_folder
          Matrixeval.working_dir.join(".matrixeval")
        end

      end
    end
  end
end