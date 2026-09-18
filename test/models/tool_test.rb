# frozen_string_literal: true

require "test_helper"

class ToolTest < ActiveSupport::TestCase
  test "display_name returns entry title when entry exists" do
    tool = Tool.create!(tool_type: "CLI")
    Entry.create!(title: "Ruby Tool", url: "https://example.com/tool",
                  entryable: tool, status: :approved)

    assert_equal "Ruby Tool", tool.display_name
  end

  test "display_name falls back to id when entry does not exist" do
    tool = Tool.create!(tool_type: "CLI")

    assert_equal "Tool ##{tool.id}", tool.display_name
  end

  test "is invalid with a non-http github_url" do
    tool = Tool.new(github_url: "not-a-url")
    assert_not tool.valid?
    assert_includes tool.errors[:github_url], "must be a valid URL starting with http:// or https://"
  end

  test "is invalid with a non-http documentation_url" do
    tool = Tool.new(documentation_url: "not-a-url")
    assert_not tool.valid?
    assert_includes tool.errors[:documentation_url], "must be a valid URL starting with http:// or https://"
  end

  test "is valid with blank urls" do
    tool = Tool.new
    assert tool.valid?
  end
end
