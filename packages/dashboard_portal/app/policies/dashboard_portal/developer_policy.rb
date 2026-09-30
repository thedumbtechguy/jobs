module DashboardPortal
  # In the dashboard a user only ever sees and edits their own listing.
  # Listings are created during onboarding, so there is no create here.
  class DeveloperPolicy < ::DeveloperPolicy
    include DashboardPortal::ResourcePolicy

    relation_scope do |relation|
      default_relation_scope(relation).where(user: user)
    end

    def create? = false

    def read? = true

    def update? = record.user_id == user.id

    def destroy? = false

    def permitted_attributes_for_read
      permitted_attributes_for_update
    end

    def permitted_attributes_for_update
      %i[
        handle name headline bio
        city region country timezone remote_ok open_to_relocation
        contact_email phone contact_visibility
        website_url github_url linkedin_url x_url
        availability seniority years_experience listed
      ]
    end
  end
end
