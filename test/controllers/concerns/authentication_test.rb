# frozen_string_literal: true

require "test_helper"

# Authentication#require_authentication is not currently wired into any
# controller as a before_action, so it needs a direct harness to be
# exercised at all.
class AuthenticationConcernTest < ActiveSupport::TestCase
  class Harness
    def self.helper_method(*); end
    def self.before_action(*); end

    include Authentication

    attr_accessor :redirected_to, :redirect_options

    def redirect_to(target, **options)
      @redirected_to = target
      @redirect_options = options
    end

    def new_session_path
      "/session/new"
    end
  end

  teardown { Current.reset }

  test "require_authentication redirects when there is no authenticated user" do
    harness = Harness.new

    harness.send(:require_authentication)

    assert_equal "/session/new", harness.redirected_to
    assert_equal "Please sign in to continue", harness.redirect_options[:alert]
  end

  test "require_authentication does not redirect an authenticated user" do
    harness = Harness.new
    Current.user = users(:admin)

    harness.send(:require_authentication)

    assert_nil harness.redirected_to
  end
end
