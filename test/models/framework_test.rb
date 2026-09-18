# frozen_string_literal: true

require "test_helper"

class FrameworkTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = Framework.create!(name: "Test Framework")
    assert_equal "Test Framework", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = Framework.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby Framework", url: "https://example.com/framework",
                          entryable: record, status: :approved)

    assert_equal "Ruby Framework", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = Framework.new
    record.save!(validate: false)

    assert_equal "Framework ##{record.id}", record.display_name
  end
end
