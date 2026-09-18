# frozen_string_literal: true

require "test_helper"

class DocumentationTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = Documentation.create!(name: "Test Documentation")
    assert_equal "Test Documentation", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = Documentation.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby Documentation", url: "https://example.com/documentation",
                          entryable: record, status: :approved)

    assert_equal "Ruby Documentation", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = Documentation.new
    record.save!(validate: false)

    assert_equal "Documentation ##{record.id}", record.display_name
  end
end
