module Matrixeval
  module Ruby
    class GemfileLocks
      class << self

        def create
          FileUtils.mkdir_p gemfile_lock_folder

          Context.all.each do |context|
            FileUtils.touch context.gemfile_lock_path
          end
        end

        private

        def gemfile_lock_folder
          Matrixeval.working_dir.join(".matrixeval/gemfile_locks")
        end

      end
    end
  end
end