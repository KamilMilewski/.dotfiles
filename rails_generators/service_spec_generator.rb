# frozen_string_literal: true

# example run:
# considering file_path: app/services/user/create.rb
# bin/rails generate service_spec --path app/services/user/create.rb
class ServiceSpecGenerator < Rails::Generators::Base
  class_option :file_path, type: :string

  # outcome spec path will be: spec/services/user/create_spec.rb
  def create_service_spec_file
    constant_name = options["file_path"].gsub(/^app\/services\//, "").gsub(/\.rb\z/, "") # would yield `user/create`
    spec_path = "spec/services/#{constant_name}_spec.rb"

    create_file spec_path, <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{constant_name.classify} do
        it "does stuff" do
        end
      end
    RUBY
  end
end
