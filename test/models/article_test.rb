# frozen_string_literal: true

require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "display_name returns entry title when entry exists" do
    article = Article.create!(platform: "Dev.to")
    Entry.create!(title: "Ruby Article", url: "https://example.com/article",
                  entryable: article, status: :approved)

    assert_equal "Ruby Article", article.display_name
  end

  test "display_name falls back to id when entry does not exist" do
    article = Article.create!(platform: "Dev.to")

    assert_equal "Article ##{article.id}", article.display_name
  end

  test "is invalid with a non-positive reading_time_minutes" do
    article = Article.new(reading_time_minutes: 0)
    assert_not article.valid?
    assert_includes article.errors[:reading_time_minutes], "must be greater than 0"
  end

  test "is valid with a positive reading_time_minutes" do
    article = Article.new(reading_time_minutes: 10)
    assert article.valid?
  end

  test "is invalid with a publication_date in the future" do
    article = Article.new(publication_date: 1.day.from_now)
    assert_not article.valid?
    assert_includes article.errors[:publication_date], "cannot be in the future"
  end

  test "is valid with a publication_date in the past" do
    article = Article.new(publication_date: 1.day.ago)
    assert article.valid?
  end

  test "is valid with blank optional fields" do
    article = Article.new
    assert article.valid?
  end
end
