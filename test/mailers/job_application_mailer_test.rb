require "test_helper"

class Hiring::JobApplicationMailerTest < ActionMailer::TestCase
  include AccountsTestHelper

  setup do
    @recruiter = create_user!
    @company = create_company!(owner: @recruiter, name: "Acme Labs")
    @job = create_job!(company: @company, title: "Rails Engineer", accepts_applications: true)
    @profile = create_profile!(name: "Kwame Mensah", handle: "kwame")
  end

  test "applying emails the company" do
    application = nil
    assert_enqueued_email_with Hiring::JobApplicationMailer, :received, params: ->(p) { p[:job_application].is_a?(Hiring::JobApplication) } do
      application = @job.job_applications.create!(profile: @profile, cover_note: "Keen to help!")
    end

    email = Hiring::JobApplicationMailer.with(job_application: application).received
    assert_equal [@recruiter.email], email.to
    assert_equal "New applicant for Rails Engineer: Kwame Mensah", email.subject
    assert_match "Keen to help!", email.text_part.body.to_s
    assert_match "/company/acme-labs/hiring/job_applications/#{application.id}", email.html_part.body.to_s
    assert_match "/@kwame", email.html_part.body.to_s
  end

  test "status changes the applicant should know about email them" do
    application = @job.job_applications.create!(profile: @profile)

    assert_enqueued_email_with Hiring::JobApplicationMailer, :status_changed, params: {job_application: application} do
      application.update!(status: :shortlisted)
    end
    assert_no_enqueued_emails { application.update!(cover_note: "edited") }
    assert_no_enqueued_emails { application.withdraw! }

    application.status = :shortlisted
    email = Hiring::JobApplicationMailer.with(job_application: application).status_changed
    assert_equal [@profile.user.email], email.to
    assert_equal "You're on the shortlist for Rails Engineer", email.subject
    assert_match "/developer/kwame/hiring/job_applications/#{application.id}", email.html_part.body.to_s

    application.status = :rejected
    email = Hiring::JobApplicationMailer.with(job_application: application).status_changed
    assert_match "decided not to move forward", email.text_part.body.to_s
    assert_match "/jobs", email.text_part.body.to_s
  end
end
