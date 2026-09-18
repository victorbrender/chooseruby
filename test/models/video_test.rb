# frozen_string_literal: true

require "test_helper"

class VideoTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = Video.create!(name: "Test Video")
    assert_equal "Test Video", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = Video.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby Video", url: "https://example.com/video",
                          entryable: record, status: :approved)

    assert_equal "Ruby Video", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = Video.new
    record.save!(validate: false)

    assert_equal "Video ##{record.id}", record.display_name
  end
end
