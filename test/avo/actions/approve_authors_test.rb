# frozen_string_literal: true

require "test_helper"

class Avo::Actions::ApproveAuthorsTest < ActiveSupport::TestCase
  test "approve action updates a single author's status to approved" do
    author = Author.create!(name: "Test Author", status: :pending)

    action = Avo::Actions::ApproveAuthors.new(record: author, resource: nil, user: nil, view: :index)
    action.handle(records: [ author ], fields: {}, current_user: nil, resource: nil)

    assert_equal "approved", author.reload.status
  end

  test "approve action processes multiple authors correctly" do
    author1 = Author.create!(name: "Author One", status: :pending)
    author2 = Author.create!(name: "Author Two", status: :pending)

    action = Avo::Actions::ApproveAuthors.new(record: author1, resource: nil, user: nil, view: :index)
    action.handle(records: [ author1, author2 ], fields: {}, current_user: nil, resource: nil)

    assert_equal "approved", author1.reload.status
    assert_equal "approved", author2.reload.status
  end
end
