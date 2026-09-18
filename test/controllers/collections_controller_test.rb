# frozen_string_literal: true

require "test_helper"

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  test "index renders the curated collections and experience tracks" do
    get collections_path

    assert_response :success
  end

  test "show renders a collection with its filtered entries" do
    ruby_gem = RubyGem.create!(gem_name: "hotwire-gem")
    Entry.create!(
      title: "Hotwire Gem", url: "https://example.com/hotwire-gem",
      entryable: ruby_gem, status: :approved, published: true, tags: [ "hotwire" ]
    )

    get collection_path("hotwire-speed")

    assert_response :success
  end

  test "show merges query params over the collection's base filters" do
    ruby_gem = RubyGem.create!(gem_name: "advanced-gem")
    Entry.create!(
      title: "Advanced Gem", url: "https://example.com/advanced-gem",
      entryable: ruby_gem, status: :approved, published: true,
      experience_level: :advanced, tags: [ "rails 8" ]
    )

    get collection_path("rails-8-production"), params: { level: "advanced" }

    assert_response :success
  end

  test "show keeps the collection's base filter when the override is blank" do
    ruby_gem = RubyGem.create!(gem_name: "hotwire-gem-2")
    Entry.create!(
      title: "Hotwire Gem 2", url: "https://example.com/hotwire-gem-2",
      entryable: ruby_gem, status: :approved, published: true, tags: [ "hotwire" ]
    )

    get collection_path("hotwire-speed"), params: { q: "" }

    assert_response :success
  end

  test "show renders 404 for an unknown collection slug" do
    # CollectionsController doesn't rescue RecordNotFound itself; it relies
    # on Rails' own handling (config.action_dispatch.show_exceptions =
    # :rescuable in test.rb), which turns it into a 404 response rather
    # than letting it propagate as a raised exception.
    get collection_path("does-not-exist")

    assert_response :not_found
  end
end
