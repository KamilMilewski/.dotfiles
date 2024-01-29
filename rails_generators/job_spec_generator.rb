# frozen_string_literal: true

# example run:
# considering file_path: app/jobs/hard_job.rb
# bin/rails generate job_spec --path app/services/user/create.rb
class JobSpecGenerator < Rails::Generators::Base
  class_option :file_path, type: :string

  # outcome spec path will be: spec/jobs/hard_job_spec.rb
  def create_job_spec_file
    constant_name = options["file_path"].gsub(/^app\/jobs\//, "").gsub(/\.rb\z/, "") # would yield `hard_job`
    spec_path = "spec/jobs/#{constant_name}_spec.rb"

    create_file spec_path, <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{constant_name.classify} do
        it "works hard" do
          described_class.new.perform()
        end
      end
    RUBY
  end
end
