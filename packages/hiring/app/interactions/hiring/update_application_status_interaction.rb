module Hiring
  # Company members move an applicant through their pipeline.
  class UpdateApplicationStatusInteraction < Hiring::ResourceInteraction
    STATUSES = %w[reviewing shortlisted rejected hired].freeze

    presents label: "Update status", icon: Phlex::TablerIcons::Progress, description: "Move this applicant along"

    attribute :resource
    attribute :status, :string

    input :status, as: :select, choices: STATUSES.map { |s| [s.humanize, s] }

    validates :status, inclusion: {in: STATUSES}

    private

    def execute
      resource.update!(status:)
      succeed(resource).with_message("#{resource.profile.name} is now #{status.humanize.downcase}.")
    rescue ActiveRecord::RecordInvalid => e
      failed(e.record.errors)
    end
  end
end
