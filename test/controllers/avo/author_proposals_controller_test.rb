# frozen_string_literal: true

require "test_helper"

class Avo::AuthorProposalsControllerTest < ActiveSupport::TestCase
  test "authorize_action blocks create, new, edit, update, and destroy" do
    controller = Avo::AuthorProposalsController.new

    assert_equal false, controller.authorize_action(:create)
    assert_equal false, controller.authorize_action(:new)
    assert_equal false, controller.authorize_action(:edit)
    assert_equal false, controller.authorize_action(:update)
    assert_equal false, controller.authorize_action(:destroy)
  end

  test "authorize_action allows other actions" do
    controller = Avo::AuthorProposalsController.new

    assert_equal true, controller.authorize_action(:index)
    assert_equal true, controller.authorize_action(:show)
  end
end
