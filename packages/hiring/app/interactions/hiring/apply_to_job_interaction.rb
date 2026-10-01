module Hiring
  # A developer applying in the app. Runs in the developer portal, where the
  # scoped entity is the applicant's own profile.
  class ApplyToJobInteraction < Hiring::ResourceInteraction
    presents label: "Apply", icon: Phlex::TablerIcons::Send, description: "Send your profile to the company"

    attribute :resource
    attribute :cover_note, :string

    input :cover_note, as: :text, hint: "Optional. Why you're a good fit."

    private

    def execute
      application = resource.job_applications.create!(profile: current_scoped_entity, cover_note:)
      succeed(application).with_message("Application sent to #{resource.company.name}.")
    rescue ActiveRecord::RecordInvalid => e
      failed(e.record.errors)
    end
  end
end
