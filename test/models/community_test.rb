# frozen_string_literal: true

require "test_helper"

class CommunityTest < ActiveSupport::TestCase
  test "display_name returns entry title when entry exists" do
    community = Community.create!(platform: "Discord", join_url: "https://discord.gg/ruby")
    Entry.create!(title: "Ruby Discord", url: "https://discord.gg/ruby",
                  entryable: community, status: :approved)

    assert_equal "Ruby Discord", community.display_name
  end

  test "display_name falls back to id when entry does not exist" do
    community = Community.create!(platform: "Discord", join_url: "https://discord.gg/ruby")

    assert_equal "Community ##{community.id}", community.display_name
  end

  test "is invalid without platform" do
    community = Community.new(join_url: "https://discord.gg/ruby")
    assert_not community.valid?
    assert_includes community.errors[:platform], "can't be blank"
  end

  test "is invalid without join_url" do
    community = Community.new(platform: "Discord")
    assert_not community.valid?
    assert_includes community.errors[:join_url], "can't be blank"
  end

  test "is invalid with a non-http join_url" do
    community = Community.new(platform: "Discord", join_url: "not-a-url")
    assert_not community.valid?
    assert_includes community.errors[:join_url], "must be a valid URL starting with http:// or https://"
  end

  test "is invalid with a non-positive member_count" do
    community = Community.new(platform: "Discord", join_url: "https://discord.gg/ruby", member_count: 0)
    assert_not community.valid?
    assert_includes community.errors[:member_count], "must be greater than 0"
  end

  test "is valid with a positive member_count" do
    community = Community.new(platform: "Discord", join_url: "https://discord.gg/ruby", member_count: 10)
    assert community.valid?
  end
end
