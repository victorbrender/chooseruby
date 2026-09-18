# frozen_string_literal: true

require "test_helper"

class BlogTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = Blog.create!(name: "Test Blog")
    assert_equal "Test Blog", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = Blog.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby Blog", url: "https://example.com/blog",
                          entryable: record, status: :approved)

    assert_equal "Ruby Blog", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = Blog.new
    record.save!(validate: false)

    assert_equal "Blog ##{record.id}", record.display_name
  end
end
