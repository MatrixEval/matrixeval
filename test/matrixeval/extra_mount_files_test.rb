# frozen_string_literal: true

require "test_helper"

class Matrixeval::ExtraMountFilesTest < MatrixevalTest

  def setup
    FileUtils.rm_rf dummy_gem_working_dir.join(".test_mount") rescue nil
    FileUtils.rm dummy_gem_working_dir.join("mount.txt") rescue nil
    FileUtils.rm_rf dummy_gem_working_dir.join(".matrixeval/schema") rescue nil
    Matrixeval.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_create
    Matrixeval::Config::YAML.stubs(:yaml).returns({
      "target" => "ruby",
      "mounts" => [
        "/matrixeval-a/b:/c/d",
        ".test_mount:/test_mount",
        "mount.txt:/app/mount.txt"
      ],
      "matrix" => {
        "ruby" => {
          "variants" => [
            { "key" => "3.0", "default" => true },
            { "key" => "3.1" }
          ]
        },
        "rails" => {
          "variants" => [
            {
              "key" => "6.1",
              "mounts" => [
                ".matrixeval/schema/rails_6_1.rb:/app/test/dummy/db/schema.rb"
              ]
            },
            {
              "key" => "7.0",
              "default" => true,
              "mounts" => [
                ".matrixeval/schema/rails_7_0.rb:/app/test/dummy/db/schema.rb"
              ]
            }
          ]
        }
      }
    })

    refute File.exist? dummy_gem_working_dir.join(".matrixeval/schema/rails_6_1.rb")
    refute File.exist? dummy_gem_working_dir.join(".matrixeval/schema/rails_7_0.rb")
    refute File.exist? dummy_gem_working_dir.join("mount.txt")
    refute File.exist? "/matrixeval-a"
    refute File.exist? dummy_gem_working_dir.join(".test_mount")

    Matrixeval::ExtraMountFiles.create

    assert File.exist? dummy_gem_working_dir.join(".matrixeval/schema/rails_6_1.rb")
    assert File.exist? dummy_gem_working_dir.join(".matrixeval/schema/rails_7_0.rb")
    assert File.exist? dummy_gem_working_dir.join("mount.txt")
    refute File.exist? "/matrixeval-a"
    refute File.exist? dummy_gem_working_dir.join(".test_mount")
  end

end
