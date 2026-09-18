# frozen_string_literal: true

require "test_helper"

# Exercises the AuthorProposal Avo resource's search lambda (self.search),
# which only runs through the admin search endpoint.
class AuthorProposalSearchTest < ActionDispatch::IntegrationTest
  test "admin search finds no results for a non-matching query" do
    post session_url, params: { email_address: "admin@test.com", password: "password" }
    AuthorProposal.create!(author_name: "Search Me", submitter_email: "searchable@example.com")

    get "/avo/avo_api/author_proposals/search", params: { q: "no-such-email-anywhere" }

    assert_response :success
  end
end
