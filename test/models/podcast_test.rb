# frozen_string_literal: true

require "test_helper"

class PodcastTest < ActiveSupport::TestCase
  test "display_name returns entry title when entry exists" do
    podcast = Podcast.create!(host: "Test Host")
    Entry.create!(title: "Ruby Podcast", url: "https://example.com/podcast",
                  entryable: podcast, status: :approved)

    assert_equal "Ruby Podcast", podcast.display_name
  end

  test "display_name falls back to id when entry does not exist" do
    podcast = Podcast.create!(host: "Test Host")

    assert_equal "Podcast ##{podcast.id}", podcast.display_name
  end

  test "is invalid with a non-positive episode_count" do
    podcast = Podcast.new(episode_count: 0)
    assert_not podcast.valid?
    assert_includes podcast.errors[:episode_count], "must be greater than 0"
  end

  test "is valid with a positive episode_count" do
    podcast = Podcast.new(episode_count: 5)
    assert podcast.valid?
  end

  test "is invalid with a non-http rss_feed_url" do
    podcast = Podcast.new(rss_feed_url: "not-a-url")
    assert_not podcast.valid?
    assert_includes podcast.errors[:rss_feed_url], "must be a valid URL starting with http:// or https://"
  end

  test "is invalid with a non-http spotify_url" do
    podcast = Podcast.new(spotify_url: "not-a-url")
    assert_not podcast.valid?
    assert_includes podcast.errors[:spotify_url], "must be a valid URL starting with http:// or https://"
  end

  test "is invalid with a non-http apple_podcasts_url" do
    podcast = Podcast.new(apple_podcasts_url: "not-a-url")
    assert_not podcast.valid?
    assert_includes podcast.errors[:apple_podcasts_url], "must be a valid URL starting with http:// or https://"
  end

  test "is valid with blank urls" do
    podcast = Podcast.new
    assert podcast.valid?
  end
end
