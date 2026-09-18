# frozen_string_literal: true

require "test_helper"

class TestingResourceTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = TestingResource.create!(name: "Test TestingResource")
    assert_equal "Test TestingResource", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = TestingResource.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby TestingResource", url: "https://example.com/testing_resource",
                          entryable: record, status: :approved)

    assert_equal "Ruby TestingResource", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = TestingResource.new
    record.save!(validate: false)

    assert_equal "TestingResource ##{record.id}", record.display_name
  end
end
