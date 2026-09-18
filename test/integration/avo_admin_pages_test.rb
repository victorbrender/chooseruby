# frozen_string_literal: true

require "test_helper"

class AvoAdminPagesTest < ActionDispatch::IntegrationTest
  setup do
    post session_url, params: { email_address: "admin@test.com", password: "password" }

    ruby_gem = RubyGem.create!(gem_name: "avo-sweep-gem")
    entry = Entry.create!(
      title: "Avo Sweep Entry",
      description: "Test",
      url: "https://example.com/avo-sweep",
      entryable: ruby_gem,
      status: :approved
    )

    @records = {
      videos: Video.create!(name: "Sweep Video"),
      users: users(:editor),
      tutorials: Tutorial.create!,
      tools: Tool.create!(is_open_source: true),
      testing_resources: TestingResource.create!(name: "Sweep Testing Resource"),
      ruby_gems: ruby_gem,
      products: Product.create!(name: "Sweep Product"),
      podcasts: Podcast.create!,
      newsletters: Newsletter.create!(name: "Sweep Newsletter"),
      job_boards: JobBoard.create!(name: "Sweep Job Board"),
      frameworks: Framework.create!(name: "Sweep Framework"),
      entry_reviews: EntryReview.create!(entry: entry, status: :approved),
      entries: entry,
      documentations: Documentation.create!(name: "Sweep Documentation"),
      directories: Directory.create!(name: "Sweep Directory"),
      development_environments: DevelopmentEnvironment.create!(name: "Sweep Dev Environment"),
      courses: Course.create!(is_free: true),
      communities: Community.create!(platform: "Discord", join_url: "https://discord.gg/sweep"),
      channels: Channel.create!(name: "Sweep Channel"),
      categories: categories(:testing),
      categories_entries: CategoriesEntry.create!(category: categories(:testing), entry: entry),
      books: Book.create!(format: :ebook),
      blogs: Blog.create!(name: "Sweep Blog"),
      author_proposals: author_proposals(:pending_comprehensive),
      authors: Author.create!(name: "Sweep Author", slug: "sweep-author", status: :approved),
      articles: Article.create!
    }
  end

  # Avo is mounted at "/avo" (config/initializers/avo.rb), so its resource
  # routes live under "/avo/resources/...". `bin/rails routes` prints them
  # without that mount prefix, which is easy to miss.
  #
  # Defined as one test per resource (rather than a single loop) so a
  # failure on one resource doesn't abort the assertion before the rest
  # even run.
  RESOURCES_FIXTURE_NAMES = %i[
    videos users tutorials tools testing_resources ruby_gems products podcasts
    newsletters job_boards frameworks entry_reviews entries documentations
    directories development_environments courses communities channels
    categories categories_entries books blogs author_proposals authors articles
  ].freeze

  RESOURCES_FIXTURE_NAMES.each do |resource|
    define_method("test_index page renders for #{resource}") do
      get "/avo/resources/#{resource}"
      assert_response :success, "expected #{resource} index to render successfully"
    end

    define_method("test_show page renders for #{resource}") do
      record = @records.fetch(resource)
      get "/avo/resources/#{resource}/#{record.id}"
      assert_response :success, "expected #{resource} show to render successfully"
    end
  end
end
