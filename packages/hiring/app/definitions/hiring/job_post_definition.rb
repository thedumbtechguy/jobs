module Hiring
  class JobPostDefinition < Hiring::ResourceDefinition
    modal false
    submit_and_continue false
    index_page_title "Jobs"

    action :publish, interaction: Hiring::PublishJobPostInteraction, category: :primary
    action :approve, interaction: Hiring::ApproveJobPostInteraction, category: :primary
    action :decline, interaction: Hiring::DeclineJobPostInteraction, modal: :centered
    action :apply, interaction: Hiring::ApplyToJobInteraction, category: :primary, modal: :centered
    action :renew, interaction: Hiring::RenewJobPostInteraction
    action :mark_filled, interaction: Hiring::MarkJobPostFilledInteraction, confirmation: "Mark this job as filled? It will stop being listed."
    action :reopen, interaction: Hiring::ReopenJobPostInteraction
    action :archive, interaction: Hiring::ArchiveJobPostInteraction, category: :danger,
      confirmation: "Archive this job? It will be hidden and can't be edited."

    field :description, as: :markdown
    field :apply_url, as: :url, label: "Application link"
    field :salary_range, label: "Salary"
    field :employment_type, label: "Type"

    display :status, as: :badge
    column :status, as: :badge
    column :expires_at, as: :date, label: "Expires"
    display :published_at, as: :date, label: "Published"
    display :expires_at, as: :date, label: "Expires"
    display :description, wrapper: {class: "col-span-full"}

    input :title, placeholder: "e.g. Senior Backend Engineer"
    input :remote_ok, as: :toggle, label: "Remote OK"
    input :accepts_applications, as: :toggle, label: "Accept applications here",
      hint: "Developers apply with their profile. You review them under Applicants."
    input :apply_url, placeholder: "https://", hint: "Or send people to your own careers page. You can use both."
    input :visibility, as: :select, label: "Who can see this job",
      choices: [["Everyone: public jobs board, shareable link", "everyone"], ["Signed-in members only", "members"]]
    display :visibility, label: "Visible to"
    input :salary_min, label: "Minimum salary"
    input :salary_max, label: "Maximum salary"
    input :salary_currency, label: "Currency", hint: "3-letter code, e.g. USD, GHS, NGN"

    search do |scope, query|
      scope.where("hiring_job_posts.title LIKE :q OR hiring_job_posts.description LIKE :q", q: "%#{query}%")
    end

    default_sort :created_at, :desc

    form_layout do
      section :role, :title, :employment_type, :seniority, label: "Role", columns: 3
      section :description, :description, label: "Description"
      section :location, :remote_ok, :city, :country, label: "Location", columns: 3
      section :salary, :salary_min, :salary_max, :salary_currency, label: "Salary", description: "Optional, but posts with a range get more applicants.", columns: 3
      section :applying, :accepts_applications, :apply_url, label: "How to apply", columns: 2
      section :visibility, :visibility, label: "Visibility"
      ungrouped label: "Other"
    end
  end
end
