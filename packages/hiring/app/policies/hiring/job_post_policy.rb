module Hiring
  # Company members managing their jobs (company portal). The developer and
  # admin portals subclass this.
  class JobPostPolicy < Hiring::ResourcePolicy
    def create? = true

    def read? = true

    def update? = record.archived_at.nil?

    # Only drafts can be deleted; published jobs are archived instead.
    def destroy? = record.published_at.nil?

    def publish? = record.publishable?

    def renew? = record.renewable?

    def mark_filled? = record.fillable?

    def reopen? = record.filled_at.present? && record.archived_at.nil?

    def archive? = record.archived_at.nil?

    def apply? = false

    def permitted_attributes_for_create
      %i[
        title description employment_type seniority
        remote_ok city country
        salary_min salary_max salary_currency
        accepts_applications apply_url
        visibility
      ]
    end

    def permitted_attributes_for_read
      %i[title status visibility employment_type seniority location salary_range description accepts_applications apply_url published_at expires_at]
    end

    def permitted_attributes_for_index
      %i[title status employment_type location expires_at]
    end

    def permitted_associations
      %i[job_applications]
    end
  end
end
