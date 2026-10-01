# Hiring emails. View at /rails/mailers/hiring_mailer.
# Uses existing development records.
class HiringMailerPreview < ActionMailer::Preview
  def review_requested = Hiring::JobReviewMailer.with(job_post: job).review_requested

  def job_approved = Hiring::JobReviewMailer.with(job_post: job).approved

  def job_declined
    Hiring::JobReviewMailer.with(job_post: job, reason: "Please add a salary range and say which city the hybrid days are in.").declined
  end

  def application_received = Hiring::JobApplicationMailer.with(job_application: application).received

  Hiring::JobApplication::NOTIFY_STATUSES.each do |status|
    define_method(:"application_#{status}") do
      application.status = status
      Hiring::JobApplicationMailer.with(job_application: application).status_changed
    end
  end

  private

  def job = Hiring::JobPost.where.not(expires_at: nil).first || Hiring::JobPost.first!

  def application = @application ||= Hiring::JobApplication.first!
end
