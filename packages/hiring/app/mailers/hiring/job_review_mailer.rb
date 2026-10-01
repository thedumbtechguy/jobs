module Hiring
  # Emails for the first-job review: admins are asked to review, and the
  # company hears back when its job is approved or declined.
  class JobReviewMailer < ::ApplicationMailer
    include PortalPathsHelper

    prepend_view_path Hiring::Engine.root.join("app/views")

    before_action { @job = params[:job_post] }

    def review_requested
      recipients = Admin.verified.pluck(:email)
      return if recipients.empty?

      @review_url = absolute(PortalPathsHelper.routes.admin_portal.hiring_job_post_path(@job))
      mail to: recipients, subject: "Review needed: #{@job.title} at #{@job.company.name}"
    end

    def approved
      @job_url = absolute(Rails.application.routes.url_helpers.public_job_path(@job))
      mail to: company_emails, subject: "Your job is live: #{@job.title}"
    end

    def declined
      @reason = params[:reason]
      @edit_url = absolute(PortalPathsHelper.routes.company_portal.company_scoped_hiring_job_post_path(company_scoped: @job.company, id: @job))
      mail to: company_emails, subject: "Changes needed: #{@job.title}"
    end

    private

    def company_emails
      @job.company.users.where(status: :verified).pluck(:email)
    end

    def absolute(path)
      options = ActionMailer::Base.default_url_options
      Rails.application.routes.url_helpers.root_url(**options).chomp("/") + path
    end
  end
end
