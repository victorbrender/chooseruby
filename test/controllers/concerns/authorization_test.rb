# frozen_string_literal: true

require "test_helper"

# Authorization#can_administer? and #ensure_can_administer are not currently
# wired into any controller as a before_action or view check, so they need a
# direct harness to be exercised at all.
class AuthorizationConcernTest < ActiveSupport::TestCase
  class Harness
    def self.helper_method(*); end

    include Authorization

    attr_accessor :current_user, :redirected_to, :redirect_options

    def redirect_to(target, **options)
      @redirected_to = target
      @redirect_options = options
    end

    def root_path
      "/"
    end
  end

  teardown { Current.reset }

  test "can_administer? is true when the current user can administer" do
    harness = Harness.new
    harness.current_user = users(:admin)

    assert harness.send(:can_administer?)
  end

  test "can_administer? is false when there is no current user" do
    harness = Harness.new

    assert_not harness.send(:can_administer?)
  end

  test "can_administer? is false when the current user cannot administer" do
    harness = Harness.new
    harness.current_user = users(:editor)

    assert_not harness.send(:can_administer?)
  end

  test "ensure_can_administer redirects non-administrators" do
    harness = Harness.new

    harness.send(:ensure_can_administer)

    assert_equal "/", harness.redirected_to
    assert_equal "You are not authorized to access this page", harness.redirect_options[:alert]
  end

  test "ensure_can_administer does not redirect administrators" do
    harness = Harness.new
    harness.current_user = users(:admin)

    harness.send(:ensure_can_administer)

    assert_nil harness.redirected_to
  end
end
