# frozen_string_literal: true

require "test_helper"

# Exercises the Entry Avo resource's has_many entry_reviews association
# table, which applies a custom scope that only runs when that association
# tab is actually loaded (not on the plain show page).
class EntryResourceTest < ActionDispatch::IntegrationTest
  setup do
    post session_url, params: { email_address: "admin@test.com", password: "password" }
  end

  test "entry_reviews association index applies its recency scope" do
    ruby_gem = RubyGem.create!(gem_name: "entry-reviews-assoc-gem")
    entry = Entry.create!(
      title: "Entry Reviews Assoc Gem", url: "https://example.com/entry-reviews-assoc-gem",
      entryable: ruby_gem, status: :approved
    )
    EntryReview.create!(entry: entry, status: :approved)

    get "/avo/resources/entries/#{entry.id}/entry_reviews"

    assert_response :success
  end

  test "tags field suggestions list all distinct tags across entries" do
    ruby_gem = RubyGem.create!(gem_name: "tags-suggestions-gem")
    Entry.create!(
      title: "Tags Suggestions Gem", url: "https://example.com/tags-suggestions-gem",
      entryable: ruby_gem, status: :approved, tags: [ "alpha", "beta" ]
    )

    resource = Avo::Resources::Entry.new(view: :show)
    resource.detect_fields
    field = resource.get_field_definitions.find { |f| f.id == :tags }
    suggestions = field.instance_variable_get(:@suggestions).call

    assert_includes suggestions, "alpha"
    assert_includes suggestions, "beta"
  end
end
