# frozen_string_literal: true

require "test_helper"

class CspReportsControllerTest < ActionDispatch::IntegrationTest
  test "create logs the raw report body and returns no content" do
    post "/csp-violation-report", params: '{"csp-report":{"violated-directive":"script-src"}}',
                                  headers: { "Content-Type" => "application/json" }

    assert_response :no_content
  end
end
