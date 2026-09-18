# frozen_string_literal: true

require "test_helper"

# Exercises the Avo admin create/update HTTP actions for the delegated-type
# resources that override `model_params`, so that override actually runs
# (the read-only sweep in avo_admin_pages_test.rb only hits index/show).
#
# Avo is mounted at "/avo" (config/initializers/avo.rb); `bin/rails routes`
# prints these routes without that mount prefix, which is easy to miss.
class AvoDelegatedTypeAdminCrudTest < ActionDispatch::IntegrationTest
  RESOURCES = {
    blogs: "blog",
    channels: "channel",
    development_environments: "development_environment",
    directories: "directory",
    documentations: "documentation",
    frameworks: "framework",
    job_boards: "job_board",
    newsletters: "newsletter",
    products: "product",
    testing_resources: "testing_resource",
    videos: "video"
  }.freeze

  setup do
    post session_url, params: { email_address: "admin@test.com", password: "password" }
  end

  RESOURCES.each do |path, param_key|
    define_method("test_can create #{param_key} via the Avo admin form") do
      assert_difference "#{param_key.camelize}.count", 1 do
        post "/avo/resources/#{path}", params: { param_key => { name: "Test #{param_key.camelize}" } }
      end

      record = param_key.camelize.constantize.order(:id).last
      assert_response :redirect
      assert_equal "Test #{param_key.camelize}", record.name
    end

    define_method("test_can update #{param_key} via the Avo admin form") do
      record = param_key.camelize.constantize.create!(name: "Original #{param_key.camelize}")

      patch "/avo/resources/#{path}/#{record.id}", params: { param_key => { name: "Renamed #{param_key.camelize}" } }

      assert_response :redirect
      assert_equal "Renamed #{param_key.camelize}", record.reload.name
    end
  end
end
