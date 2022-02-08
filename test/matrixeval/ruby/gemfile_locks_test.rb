# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::GemfileLocksTest < MatrixevalTest

  def setup
    FileUtils.rm Dir.glob(dummy_gem_working_dir.join(".matrixeval/Gemfile.lock.*"))
    Matrixeval.stubs(:working_dir).returns(dummy_gem_working_dir)
  end

  def test_create
    Matrixeval::Ruby::Config::YAML.stubs(:yaml).returns({
      "version" => "0.1",
      "target" => "ruby",
      "matrix" => {
        "ruby" => {
          "variants" => [
            { "key" => "3.0", "default" => true },
            { "key" => "3.1" }
          ]
        },
        "rails" => {
          "variants" => [
            { "key" => "6.1" },
            { "key" => "7.0", "default" => true }
          ]
        }
      }
    })

    refute File.exist? gemfile_lock("ruby_3_0_rails_6_1")
    refute File.exist? gemfile_lock("ruby_3_0_rails_7_0")
    refute File.exist? gemfile_lock("ruby_3_1_rails_6_1")
    refute File.exist? gemfile_lock("ruby_3_1_rails_6_1")

    Matrixeval::Ruby::GemfileLocks.create

    assert File.exist? gemfile_lock("ruby_3_0_rails_6_1")
    assert File.exist? gemfile_lock("ruby_3_0_rails_7_0")
    assert File.exist? gemfile_lock("ruby_3_1_rails_6_1")
    assert File.exist? gemfile_lock("ruby_3_1_rails_6_1")
  end

  def gemfile_lock(suffix)
    dummy_gem_working_dir.join(".matrixeval/Gemfile.lock.#{suffix}")
  end

end
