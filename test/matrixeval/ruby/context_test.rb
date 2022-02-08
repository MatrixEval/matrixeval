# frozen_string_literal: true

require "test_helper"

class Matrixeval::Ruby::ContextTest < MatrixevalTest

  def setup
    @ruby_vector = Matrixeval::Ruby::Vector.new("ruby", {"key" => "ruby"})
    @sidekiq_vector = Matrixeval::Ruby::Vector.new("sidekiq", {"key" => "sidekiq"})
    @rails_vector = Matrixeval::Ruby::Vector.new("rails", {"key" => "rails"})

    @ruby_3_variant = Matrixeval::Ruby::Variant.new({"key" => "3.0"}, @ruby_vector)
    @sidekiq_5_variant = Matrixeval::Ruby::Variant.new(
      {
        "key" => "5.0",
        "env" => [{"SIDEKIQ_VERSION" => "5.0.0"}]
      }, @sidekiq_vector)

    @rails_6_variant = Matrixeval::Ruby::Variant.new(
      {
        "key" => "6.1",
        "env" => [{"RAILS_VERSION" => "6.1.0"}]
      }, @rails_vector)

    @context = Matrixeval::Ruby::Context.new(
      main_variant: @ruby_3_variant,
      rest_variants: [@sidekiq_5_variant, @rails_6_variant]
    )
  end

  def test_main_variant
    assert @context.main_variant.is_a?(Matrixeval::Ruby::Variant)
    assert_equal "ruby", @context.main_variant.vector.key
    assert_equal "3.0", @context.main_variant.key
  end

  def test_rest_variants
    assert_equal 2, @context.rest_variants.count
    assert_equal "rails", @context.rest_variants[0].vector.key
    assert_equal "6.1", @context.rest_variants[0].key
    assert_equal "sidekiq", @context.rest_variants[1].vector.key
    assert_equal "5.0", @context.rest_variants[1].key
  end

  def test_id
    assert_equal "ruby_3_0_rails_6_1_sidekiq_5_0", @context.id
  end

  def test_env
    expected_env = [
      {"RAILS_VERSION" => "6.1.0"},
      {"SIDEKIQ_VERSION" => "5.0.0"}
    ]
    assert_equal expected_env, @context.env
  end

  def test_docker_compose_service_name
    assert_equal "ruby_3_0", @context.docker_compose_service_name
  end

  def test_gemfile_lock_path
    Matrixeval.stubs(:working_dir).returns(Pathname.new("working_dir"))

    assert_equal "working_dir/.matrixeval/Gemfile.lock.ruby_3_0_rails_6_1_sidekiq_5_0", @context.gemfile_lock_path.to_s
  end

  def test_variants
    assert_equal 3, @context.variants.count
    assert_equal "ruby", @context.variants[0].vector.key
    assert_equal "3.0", @context.variants[0].key
    assert_equal "rails", @context.variants[1].vector.key
    assert_equal "6.1", @context.variants[1].key
    assert_equal "sidekiq", @context.variants[2].vector.key
    assert_equal "5.0", @context.variants[2].key
  end

  def test_all
    Matrixeval::Ruby::Config.stubs(:variant_combinations).returns([
      [
        @ruby_3_variant,
        @sidekiq_5_variant,
        @rails_6_variant
      ]
    ])

    contexts =  Matrixeval::Ruby::Context.all

    assert_equal 1, contexts.count
    assert contexts[0].is_a?(Matrixeval::Ruby::Context)
    assert_equal @ruby_3_variant, contexts[0].main_variant
    assert_equal [@rails_6_variant, @sidekiq_5_variant], contexts[0].rest_variants
  end

end
