# frozen_string_literal: true

require "test_helper"

class DevelopmentEnvironmentTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = DevelopmentEnvironment.create!(name: "Test DevelopmentEnvironment")
    assert_equal "Test DevelopmentEnvironment", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = DevelopmentEnvironment.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby DevelopmentEnvironment", url: "https://example.com/development_environment",
                          entryable: record, status: :approved)

    assert_equal "Ruby DevelopmentEnvironment", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = DevelopmentEnvironment.new
    record.save!(validate: false)

    assert_equal "DevelopmentEnvironment ##{record.id}", record.display_name
  end
end
