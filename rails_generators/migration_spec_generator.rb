# frozen_string_literal: true

# example run:
# bin/rails generate migration_spec --file_path spec/db/migrate/20230731125129_do_stuff.rb
class MigrationSpecGenerator < Rails::Generators::Base
  class_option :file_path, type: :string

  def create_migration_spec_file
    # Given following file_path spec/db/migrate/20230731125129_do_stuff.rb
    migration_name_with_time = File.basename(options["file_path"], ".*")                          # would yield 20230731125129_do_stuff
    migration_class_name     = migration_name_with_time.gsub(/^\d{14}_/, "").camelize

    create_file "spec/db/migrate/#{migration_name_with_time}_spec.rb", <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"
      require Rails.root.join("db", "migrate", "#{migration_name_with_time}")

      RSpec.describe #{migration_class_name} do
        describe "#up" do
          it "fill me" do
            expect { described_class.new.up }
              .to change { "something" }.to(nil)
              .and change { "another something" }.to(nil)
              .and not_change { "forbidden something" }
          end
        end

        describe "#down" do
          it "fill me" do
            expect { described_class.new.up }
              .to change { "something" }.to(nil)
              .and change { "another something" }.to(nil)
              .and not_change { "forbidden something" }
          end
        end
      end
    RUBY
  end
end
