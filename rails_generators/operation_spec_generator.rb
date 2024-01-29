# frozen_string_literal: true

# example run:
# considering file_path: app/concepts/user/create.rb
# bin/rails generate service_spec --file_path app/concepts/user/create.rb
class OperationSpecGenerator < Rails::Generators::Base
  class_option :file_path, type: :string

  # outcome spec path will be: spec/concepts/user/create_spec.rb
  def create_operation_spec_file
    constant_name = options["file_path"].gsub(/^app\/concepts\//, "").gsub(/\.rb\z/, "") # would yield `user/create`
    spec_path = "spec/concepts/#{constant_name}_spec.rb"

    create_file spec_path, <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{constant_name.classify} do
        let(:trial)             { create :trial, :active }
        let(:user)              { create :user, :admin }
        let(:current_user)      { CurrentUser.new(user, trial) }
        let(:dependency_params) { { "current_user" => current_user, "trial" => trial } }
        let(:params)            { {} }

        it "returns success" do
        end
      end
    RUBY
  end
end
