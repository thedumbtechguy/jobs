module Forms
  # The profile fields asked for at onboarding and on /setup/developer.
  module DeveloperProfileFields
    private

    def developer_profile_fields
      fields_wrapper do
        text :first_name, required: true
        text :other_names, hint: "Middle and last names"
        text :handle, span: true, required: true, hint: "Your public page will be at /@handle"
        text :headline, span: true, placeholder: "e.g. Backend engineer, Rails and Postgres",
          hint: "One line on what you do. It shows under your name in the directory and on your profile."
        country :country
        text :city
      end
    end
  end
end
