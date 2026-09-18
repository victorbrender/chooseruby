# frozen_string_literal: true

require "test_helper"

# Exercises the AuthorProposal Avo resource's computed `changes_summary` and
# `proposal_type` field blocks directly.
#
# Avo's field blocks are run through `instance_exec` with no positional
# arguments (see Avo::ExecutionContext#handle), so the `|record|` block
# parameter these two fields declare is always nil at render time -- it
# shadows the `record` accessor the execution context makes available under
# the same name. In practice this means both fields always render as "" in
# the real app, regardless of the underlying proposal. That's a pre-existing
# bug in the resource, not something this test suite changes; calling the
# raw blocks directly (with the record actually passed as an argument, the
# way the block signature expects) is the only way to exercise their real
# branches.
class AuthorProposalResourceTest < ActionDispatch::IntegrationTest
  setup do
    @resource = Avo::Resources::AuthorProposal.new(view: :show)
    @resource.detect_fields
  end

  def changes_summary_for(record)
    field = @resource.get_field_definitions.find { |f| f.id == :changes_summary }
    field.instance_variable_get(:@block).call(record)
  end

  def proposal_type_for(record)
    field = @resource.get_field_definitions.find { |f| f.id == :proposal_type }
    field.instance_variable_get(:@block).call(record)
  end

  test "both computed fields return blank when called without a record" do
    assert_equal "", changes_summary_for(nil)
    assert_equal "", proposal_type_for(nil)
  end

  test "proposal_type reports 'New Author' for a new-author proposal" do
    proposal = AuthorProposal.create!(author_name: "Type Check Author", submitter_email: "type-check@example.com")

    assert_equal "New Author", proposal_type_for(proposal)
  end

  test "proposal_type reports 'Edit Existing Author' for an existing-author proposal" do
    author = Author.create!(name: "Type Check Existing", status: :approved)
    proposal = AuthorProposal.create!(author: author, bio_text: "Update", submitter_email: "type-check-2@example.com")

    assert_equal "Edit Existing Author", proposal_type_for(proposal)
  end

  test "changes_summary for a new-author proposal with a matched resource and link updates" do
    entry = Entry.create!(title: "Matched Entry", url: "https://example.com/matched", status: :approved)
    proposal = AuthorProposal.create!(
      author_name: "New Author",
      submitter_email: "new-author@example.com",
      resource_url: "https://example.com/matched",
      matched_entry: entry,
      link_updates: { "github_url" => "https://github.com/newauthor" },
      bio_text: "Proposed bio",
      description_text: "Proposed description"
    )

    summary = changes_summary_for(proposal)

    assert_match "Creating new author: New Author", summary
    assert_match "Matched entry ##{entry.id}", summary
    assert_match "github_url: (blank) → https://github.com/newauthor", summary
    assert_match "Bio:", summary
    assert_match "Description:", summary
  end

  test "changes_summary for an existing-author proposal with an unmatched resource url" do
    author = Author.create!(name: "Existing Author", bio: "Existing bio", github_url: "https://github.com/existing", status: :approved)
    proposal = AuthorProposal.create!(
      author: author,
      submitter_email: "existing-author@example.com",
      resource_url: "https://unmatched.example.com/resource",
      link_updates: { "github_url" => "https://github.com/updated" },
      bio_text: "Proposed bio update"
    )

    summary = changes_summary_for(proposal)

    assert_match "Editing author: Existing Author", summary
    assert_match "Unmatched URL - http://unmatched.example.com/resource", summary
    assert_match "github_url: https://github.com/existing → https://github.com/updated", summary
    assert_match "Current: Existing bio", summary
  end

  test "changes_summary handles an author_id that no longer resolves to a real author" do
    # In-memory only: a persisted row can't have an author_id dangling like
    # this (foreign key), but the field block only needs a record that
    # responds like an AuthorProposal, not a saved one.
    proposal = AuthorProposal.new(author_id: 999_999_999, bio_text: "Some bio", submitter_email: "orphan@example.com")
    proposal.strict_loading!(false)

    summary = changes_summary_for(proposal)

    assert_match "Editing author:", summary
    assert_match "Current: (blank)", summary
  end

  test "changes_summary handles a matched_entry_id that no longer resolves to a real entry" do
    proposal = AuthorProposal.new(
      author_name: "Orphan Match Author",
      resource_url: "https://example.com/orphan-match",
      matched_entry_id: 999_999_999,
      submitter_email: "orphan-match@example.com"
    )
    proposal.strict_loading!(false)

    summary = changes_summary_for(proposal)

    assert_match "Matched entry #999999999", summary
  end

  test "changes_summary for a minimal proposal with no resource, link, bio, or description changes" do
    proposal = AuthorProposal.create!(
      author_name: "Minimal Author",
      submitter_email: "minimal@example.com"
    )

    summary = changes_summary_for(proposal)

    assert_match "Creating new author: Minimal Author", summary
    assert_no_match "Resource:", summary
    assert_no_match "Link Updates:", summary
    assert_no_match "Bio:", summary
    assert_no_match "Description:", summary
  end

  test "show page still renders successfully for a proposal (fields always blank in practice)" do
    post session_url, params: { email_address: "admin@test.com", password: "password" }
    proposal = AuthorProposal.create!(author_name: "Rendered Author", submitter_email: "rendered@example.com")

    get "/avo/resources/author_proposals/#{proposal.id}"

    assert_response :success
  end
end
