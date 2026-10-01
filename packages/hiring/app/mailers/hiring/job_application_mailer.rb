module Hiring
  # Keeps both sides of an in-app application informed: the company when
  # someone applies, the applicant when the company moves them along.
  class JobApplicationMailer < ::ApplicationMailer
    include PortalPathsHelper

    prepend_view_path Hiring::Engine.root.join("app/views")

    before_action do
      @application = params[:job_application]
      @job = @application.job_post
      @company = @job.company
      @profile = @application.profile
    end

    def received
      recipients = @company.users.where(status: :verified).pluck(:email)
      return if recipients.empty?

      @application_url = absolute_url(company_portal_application_path(@company, @application))
      @profile_url = absolute_url(Rails.application.routes.url_helpers.developer_page_path(handle: @profile.handle))
      mail to: recipients, subject: "New applicant for #{@job.title}: #{@profile.name}"
    end

    def status_changed
      @message = params[:message]
      @application_url = absolute_url(developer_portal_application_path(@profile, @application))
      @jobs_url = absolute_url(Rails.application.routes.url_helpers.public_jobs_path)
      mail to: @profile.user.email, subject: status_subject
    end

    private

    def status_subject
      case @application.status
      when "shortlisted" then "You're on the shortlist for #{@job.title}"
      when "hired" then "#{@company.name} wants to hire you"
      else "An update on your application to #{@company.name}"
      end
    end
  end
end
