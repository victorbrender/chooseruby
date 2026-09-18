# frozen_string_literal: true

require "test_helper"

class AuthorProposalsControllerGetActionsTest < ActionDispatch::IntegrationTest
  test "GET new renders the edit-proposal form for an approved author" do
    author = Author.create!(name: "Existing Author", status: :approved)

    get propose_author_edit_path(author.id)

    assert_response :success
  end

  test "GET new renders 404 for an author that does not exist" do
    get propose_author_edit_path(999_999)

    assert_response :not_found
  end

  test "GET new_author renders the new-author proposal form" do
    get new_author_proposal_path

    assert_response :success
  end

  test "GET success renders the confirmation page for an existing proposal" do
    proposal = AuthorProposal.create!(author_name: "Some Author", submitter_email: "someone@example.com")

    get author_proposal_success_path(proposal)

    assert_response :success
  end

  test "GET success renders 404 for a proposal that does not exist" do
    get author_proposal_success_path(999_999)

    assert_response :not_found
  end

  test "POST create re-renders the edit form when an existing-author proposal fails to save" do
    author = Author.create!(name: "Author For Failure", status: :approved)

    post author_proposals_path, params: {
      author_proposal: {
        author_id: author.id,
        submitter_email: "not-an-email"
      }
    }

    assert_response :unprocessable_entity
  end

  test "POST create re-renders the new-author form when a new-author proposal fails to save" do
    post author_proposals_path, params: {
      author_proposal: {
        submitter_email: "not-an-email"
      }
    }

    assert_response :unprocessable_entity
  end
end
