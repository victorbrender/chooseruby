# frozen_string_literal: true

require "test_helper"

class RubyGemTest < ActiveSupport::TestCase
  test "display_name returns entry title when entry exists" do
    ruby_gem = RubyGem.create!(gem_name: "rspec")
    Entry.create!(title: "RSpec", url: "https://rspec.info",
                  entryable: ruby_gem, status: :approved)

    assert_equal "RSpec", ruby_gem.display_name
  end

  test "display_name falls back to gem_name when entry does not exist" do
    ruby_gem = RubyGem.create!(gem_name: "rspec")

    assert_equal "rspec", ruby_gem.display_name
  end

  # NOTE: there is no test for the id-only fallback branch of display_name
  # (entry nil AND gem_name nil): gem_name is NOT NULL at the database level,
  # so that state can't exist in a persisted record even bypassing Rails
  # validations.

  test "is invalid without a gem_name" do
    ruby_gem = RubyGem.new
    assert_not ruby_gem.valid?
    assert_includes ruby_gem.errors[:gem_name], "can't be blank"
  end

  test "is invalid with a duplicate gem_name" do
    RubyGem.create!(gem_name: "rspec")
    duplicate = RubyGem.new(gem_name: "rspec")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:gem_name], "has already been taken"
  end

  test "is invalid with a non-http rubygems_url" do
    ruby_gem = RubyGem.new(gem_name: "rspec", rubygems_url: "not-a-url")
    assert_not ruby_gem.valid?
    assert_includes ruby_gem.errors[:rubygems_url], "must be a valid URL starting with http:// or https://"
  end

  test "is invalid with a non-http github_url" do
    ruby_gem = RubyGem.new(gem_name: "rspec", github_url: "not-a-url")
    assert_not ruby_gem.valid?
    assert_includes ruby_gem.errors[:github_url], "must be a valid URL starting with http:// or https://"
  end

  test "is invalid with a non-http documentation_url" do
    ruby_gem = RubyGem.new(gem_name: "rspec", documentation_url: "not-a-url")
    assert_not ruby_gem.valid?
    assert_includes ruby_gem.errors[:documentation_url], "must be a valid URL starting with http:// or https://"
  end

  test "is invalid with a negative downloads_count" do
    ruby_gem = RubyGem.new(gem_name: "rspec", downloads_count: -1)
    assert_not ruby_gem.valid?
    assert_includes ruby_gem.errors[:downloads_count], "must be greater than or equal to 0"
  end

  test "is valid with a zero downloads_count" do
    ruby_gem = RubyGem.new(gem_name: "rspec", downloads_count: 0)
    assert ruby_gem.valid?
  end
end
