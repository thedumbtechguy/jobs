module Hiring
  # Company members reviewing applicants (company portal). Applications are
  # only created through the Apply action in the developer portal.
  class JobApplicationPolicy < Hiring::ResourcePolicy
    def create? = false

    def read? = true

    def update? = false

    def destroy? = false

    def update_status? = !record.withdrawn?

    def withdraw? = false

    def permitted_attributes_for_read
      %i[profile job_post status cover_note created_at]
    end

    def permitted_attributes_for_index
      %i[profile job_post status created_at]
    end
  end
end
