# frozen_string_literal: true

require "test_helper"

class ChannelTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    channel = Channel.create!(name: "Test Channel")
    assert_equal "Test Channel", channel.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    channel = Channel.new
    channel.save!(validate: false)
    entry = Entry.create!(title: "Ruby Channel", url: "https://example.com/channel",
                          entryable: channel, status: :approved)

    assert_equal "Ruby Channel", channel.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    channel = Channel.new
    channel.save!(validate: false)

    assert_equal "Channel ##{channel.id}", channel.display_name
  end
end
