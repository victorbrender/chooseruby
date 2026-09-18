# frozen_string_literal: true

require "test_helper"

class Avo::Actions::PublishEntriesTest < ActiveSupport::TestCase
  test "publish action sets a single entry's published flag to true" do
    ruby_gem = RubyGem.create!(gem_name: "test-gem")
    entry = Entry.create!(
      title: "Test Entry",
      url: "https://example.com",
      entryable: ruby_gem,
      status: :approved,
      published: false
    )

    action = Avo::Actions::PublishEntries.new(record: entry, resource: nil, user: nil, view: :index)
    action.handle(records: [ entry ], fields: {}, current_user: nil, resource: nil)

    assert entry.reload.published
  end

  test "publish action processes multiple entries correctly" do
    ruby_gem1 = RubyGem.create!(gem_name: "test-gem-1")
    entry1 = Entry.create!(
      title: "Test Entry 1", url: "https://example.com/1",
      entryable: ruby_gem1, status: :approved, published: false
    )
    ruby_gem2 = RubyGem.create!(gem_name: "test-gem-2")
    entry2 = Entry.create!(
      title: "Test Entry 2", url: "https://example.com/2",
      entryable: ruby_gem2, status: :approved, published: false
    )

    action = Avo::Actions::PublishEntries.new(record: entry1, resource: nil, user: nil, view: :index)
    action.handle(records: [ entry1, entry2 ], fields: {}, current_user: nil, resource: nil)

    assert entry1.reload.published
    assert entry2.reload.published
  end
end
