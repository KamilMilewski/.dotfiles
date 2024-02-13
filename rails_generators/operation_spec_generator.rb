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
    resource_name = constant_name.gsub(/\/\w+\z/, "") # would yield `user`

    create_file spec_path, <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{constant_name.camelize.constantize} do
        let(:trial)             { create :trial, :active }
        let(:user)              { create :user, :with_role, :with_trial, trial: trial }
        let(:current_user)      { CurrentUser.new(user, trial) }
        let(:dependency_params) { { "current_user" => current_user, "trial" => trial } }
        let(:params)            { {} }

        before do
          user.roles.first.tap { |object| object.grants = ["#{resource_name}:index"] }.save!
        end

        it "works" do
          result = described_class.call(params: params, **dependency_params)
          expect(result["model"]).to eq([])
        end

        it "returns policy fail when no trial is authorized for user" do
          user.user_trials.first.destroy!

          result = described_class.call(params: params, **dependency_params)

          expect(result["result.policy.default"].success?).to eq false
        end

        it "returns policy fail when trial is authorized but grant is missing" do
          user.roles.first.tap { |object| object.grants = [] }.save!

          result = described_class.call(params: params, **dependency_params)

          expect(result["result.policy.default"].success?).to eq false
        end

        it "returns policy fail when trial is authorized but grant is missing right action" do
          user.roles.first.tap { |object| object.grants = ["#{resource_name}:fake"] }.save!

          result = described_class.call(params: params, **dependency_params)

          expect(result["result.policy.default"].success?).to eq false
        end
      end
    RUBY
  end
end
