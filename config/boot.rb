# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# `bin/rails test` doesn't set ENV["RAILS_ENV"] until after config/boot.rb
# has already loaded (it's set inside Rails::Command::TestCommand, which
# only runs once `rails/commands` is required below), so checking the env
# var alone misses the plain `bin/rails test` invocation entirely -- it only
# caught runs that explicitly exported RAILS_ENV=test themselves. ARGV is
# fixed from process start, so checking for the `test` subcommand there
# catches the common case too.
if ENV["RAILS_ENV"] == "test" || ARGV.first == "test"
  ENV["RAILS_ENV"] ||= "test"

  # Must start before the app boots: `bin/rails test` runs initializers to
  # discover test files before test_helper.rb loads, so starting coverage
  # there misses anything only required during initialization.
  require "simplecov"
  SimpleCov.start do
    load_profile "rails"
    skip "/lib/imports/" # one-off data migration scripts, not app logic
    skip "/lib/tasks/" # rake glue; logic lives in tested classes per docs/llms/rake.md
    skip %r{\ARakefile\z} # Rails' rake bootstrapping, never exercised by `bin/rails test`

    # Generated boilerplate subclasses with zero lines of their own logic (just
    # `class X < Y; end`). SimpleCov reports 0% for a file with no coverable
    # lines rather than treating it as vacuously covered, so these would block
    # `minimum 100, per: :file` forever regardless of what's tested.
    skip "app/jobs/application_job.rb"
    skip "app/channels/application_cable/channel.rb"
    skip "app/controllers/avo/articles_controller.rb"
    skip "app/controllers/avo/authors_controller.rb"
    skip "app/controllers/avo/books_controller.rb"
    skip "app/controllers/avo/categories_controller.rb"
    skip "app/controllers/avo/categories_entries_controller.rb"
    skip "app/controllers/avo/communities_controller.rb"
    skip "app/controllers/avo/courses_controller.rb"
    skip "app/controllers/avo/entries_controller.rb"
    skip "app/controllers/avo/entry_reviews_controller.rb"
    skip "app/controllers/avo/podcasts_controller.rb"
    skip "app/controllers/avo/ruby_gems_controller.rb"
    skip "app/controllers/avo/tools_controller.rb"
    skip "app/controllers/avo/tutorials_controller.rb"
    skip "app/controllers/avo/users_controller.rb"

    coverage :line do
      minimum 100
      minimum 100, per: :file
    end

    coverage :branch do
      ignore :eval_generated
      minimum 100
      minimum 100, per: :file
    end
  end
end

unless ENV["RAILS_ENV"] == "test"
  # Bootsnap caches compiled bytecode across process runs, and a cache entry
  # compiled without coverage active is reused as-is even once SimpleCov
  # starts, silently zeroing out coverage for whatever file it belongs to.
  require "bootsnap/setup" # Speed up boot time by caching expensive operations.
end
