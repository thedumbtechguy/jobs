module Forms
  # The profile fields asked for at onboarding and on /setup/developer.
  module DeveloperProfileFields
    private

    def developer_profile_fields
      fields_wrapper do
        text :name, label: "Your name"
        text :handle, hint: "Your public page will be at /@handle"
        text :headline, span: true, placeholder: "e.g. Backend engineer, Rails and Postgres"
        text :city
        text :country
      end
    end
  end
end
