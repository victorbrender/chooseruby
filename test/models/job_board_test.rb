# frozen_string_literal: true

require "test_helper"

class JobBoardTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = JobBoard.create!(name: "Test JobBoard")
    assert_equal "Test JobBoard", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = JobBoard.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby JobBoard", url: "https://example.com/job_board",
                          entryable: record, status: :approved)

    assert_equal "Ruby JobBoard", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = JobBoard.new
    record.save!(validate: false)

    assert_equal "JobBoard ##{record.id}", record.display_name
  end
end
