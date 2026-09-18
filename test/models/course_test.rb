# frozen_string_literal: true

require "test_helper"

class CourseTest < ActiveSupport::TestCase
  test "display_name returns entry title when entry exists" do
    course = Course.create!(platform: "Udemy")
    Entry.create!(title: "Rails Course", url: "https://example.com/course",
                  entryable: course, status: :approved)

    assert_equal "Rails Course", course.display_name
  end

  test "display_name falls back to id when entry does not exist" do
    course = Course.create!(platform: "Udemy")

    assert_equal "Course ##{course.id}", course.display_name
  end

  test "is invalid with a non-positive duration_hours" do
    course = Course.new(duration_hours: 0)
    assert_not course.valid?
    assert_includes course.errors[:duration_hours], "must be greater than 0"
  end

  test "is valid with a positive duration_hours" do
    course = Course.new(duration_hours: 3.5)
    assert course.valid?
  end

  test "is invalid with a negative price_cents" do
    course = Course.new(price_cents: -1)
    assert_not course.valid?
    assert_includes course.errors[:price_cents], "must be greater than or equal to 0"
  end

  test "is valid with a zero price_cents" do
    course = Course.new(price_cents: 0)
    assert course.valid?
  end

  test "is invalid with a non-http enrollment_url" do
    course = Course.new(enrollment_url: "not-a-url")
    assert_not course.valid?
    assert_includes course.errors[:enrollment_url], "must be a valid URL starting with http:// or https://"
  end

  test "is valid with a blank enrollment_url" do
    course = Course.new(enrollment_url: nil)
    assert course.valid?
  end
end
