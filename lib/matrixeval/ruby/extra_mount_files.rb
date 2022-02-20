module Matrixeval
  module Ruby
    class ExtraMountFiles
      class << self

        def create
          Config.all_mounts.each do |mount|
            local_path, _ = mount.split(':')
            next mount if Pathname.new(local_path).absolute?

            local_path = Matrixeval.working_dir.join(local_path)
            next if local_path.extname.empty?
            next if local_path.ascend.none? { |path| path == Matrixeval.working_dir }

            FileUtils.mkdir_p local_path.dirname
            FileUtils.touch local_path
          end
        end

      end
    end
  end
end