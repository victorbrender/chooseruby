# frozen_string_literal: true

require "test_helper"

class NewsletterTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = Newsletter.create!(name: "Test Newsletter")
    assert_equal "Test Newsletter", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = Newsletter.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby Newsletter", url: "https://example.com/newsletter",
                          entryable: record, status: :approved)

    assert_equal "Ruby Newsletter", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = Newsletter.new
    record.save!(validate: false)

    assert_equal "Newsletter ##{record.id}", record.display_name
  end
end
