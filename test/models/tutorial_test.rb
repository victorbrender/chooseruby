# frozen_string_literal: true

require "test_helper"

class TutorialTest < ActiveSupport::TestCase
  test "display_name returns entry title when entry exists" do
    tutorial = Tutorial.create!(reading_time_minutes: 10)
    Entry.create!(title: "Ruby Tutorial", url: "https://example.com/tutorial",
                  entryable: tutorial, status: :approved)

    assert_equal "Ruby Tutorial", tutorial.display_name
  end

  test "display_name falls back to id when entry does not exist" do
    tutorial = Tutorial.create!(reading_time_minutes: 10)

    assert_equal "Tutorial ##{tutorial.id}", tutorial.display_name
  end

  test "is invalid with a non-positive reading_time_minutes" do
    tutorial = Tutorial.new(reading_time_minutes: 0)
    assert_not tutorial.valid?
    assert_includes tutorial.errors[:reading_time_minutes], "must be greater than 0"
  end

  test "is valid with a positive reading_time_minutes" do
    tutorial = Tutorial.new(reading_time_minutes: 10)
    assert tutorial.valid?
  end

  test "is invalid with a publication_date in the future" do
    tutorial = Tutorial.new(publication_date: 1.day.from_now)
    assert_not tutorial.valid?
    assert_includes tutorial.errors[:publication_date], "cannot be in the future"
  end

  test "is valid with a publication_date in the past" do
    tutorial = Tutorial.new(publication_date: 1.day.ago)
    assert tutorial.valid?
  end

  test "is valid with blank optional fields" do
    tutorial = Tutorial.new
    assert tutorial.valid?
  end
end
