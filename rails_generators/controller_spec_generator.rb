# frozen_string_literal: true

# example run:
# bin/rails generate controller_spec --file_path app/controllers/api/v1/some/users_controller.rb
class ControllerSpecGenerator < Rails::Generators::Base
  class_option :file_path, type: :string

  def create_controller_spec_file
    # Given following file_path app/controllers/api/v1/some/users_controller.rb
    controller_name = options["file_path"].gsub(/^app\/controllers\//, "").gsub(/.rb\z/, "") # would yield `api/v1/some/users_controller`
    resource_name = File.basename(controller_name, ".*").gsub(/_controller\z/, "") # would yield `users`

    create_file "spec/requests/#{controller_name}_spec.rb", <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{controller_name.camelize.constantize} do
        let(:trial)  { create :trial, :active }
        let(:user)   { create :user, :with_role, :with_trial, trial: trial }
        let(:#{resource_name.singularize}) { create :#{resource_name.singularize}, trial: trial }

        describe "#index" do
          let(:path) { "/api/v1/trials/#\{trial.id\}/#{controller_name.gsub(/_controller\z/, "")}" }

          it "returns unauthorized when user isn't signed in" do
            get_json path, params: {}

            expect(response.status).to eq 401
          end

          it "returns forbidden when user doesn't have grant" do
            login_as user

            get path, params: {}

            expect(response.status).to eq 403
          end

          it "returns records when user signed in" do
            user.roles.first.tap { |object| object.grants = ["#{resource_name.singularize}:index"] }.save!
            login_as user

            get_json path, params: { page: 1, per: 25 }

            expect(response.status).to                            eq 200
            expect(response_json["meta"]["total"]).to             eq(-1)
            expect(response_json["#{resource_name}"].count).to    eq 1
            expect(response_json["#{resource_name}"][0]["id"]).to eq record.id
          end
        end
      end
    RUBY
  end
end
