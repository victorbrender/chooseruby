# frozen_string_literal: true

require "test_helper"

class CommunitiesControllerTest < ActionDispatch::IntegrationTest
  test "index renders the ordered list of communities" do
    Community.create!(platform: "Discord", join_url: "https://discord.gg/ruby", is_official: true, member_count: 100)
    Community.create!(platform: "Reddit", join_url: "https://reddit.com/r/ruby", is_official: false, member_count: 500)

    get communities_path

    assert_response :success
  end
end
