# frozen_string_literal: true

require "test_helper"

class DirectoryTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = Directory.create!(name: "Test Directory")
    assert_equal "Test Directory", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = Directory.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby Directory", url: "https://example.com/directory",
                          entryable: record, status: :approved)

    assert_equal "Ruby Directory", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = Directory.new
    record.save!(validate: false)

    assert_equal "Directory ##{record.id}", record.display_name
  end
end
