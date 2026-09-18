# frozen_string_literal: true

require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "why_ruby renders successfully" do
    get why_ruby_path

    assert_response :success
  end

  test "mission renders successfully" do
    get mission_path

    assert_response :success
  end

  test "roadmap renders successfully" do
    get roadmap_path

    assert_response :success
  end
end
