# frozen_string_literal: true

require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "display_name returns name when name is present" do
    record = Product.create!(name: "Test Product")
    assert_equal "Test Product", record.display_name
  end

  test "display_name falls back to entry title when name is blank" do
    record = Product.new
    record.save!(validate: false)
    entry = Entry.create!(title: "Ruby Product", url: "https://example.com/product",
                          entryable: record, status: :approved)

    assert_equal "Ruby Product", record.display_name
  end

  test "display_name falls back to id when name and entry are both absent" do
    record = Product.new
    record.save!(validate: false)

    assert_equal "Product ##{record.id}", record.display_name
  end
end
