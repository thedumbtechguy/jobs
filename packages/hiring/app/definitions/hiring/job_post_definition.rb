module Hiring
  class JobPostDefinition < Hiring::ResourceDefinition
    modal false
    submit_and_continue false
    index_page_title "Posts"

    action :publish, interaction: Hiring::PublishJobPostInteraction, category: :primary
    action :approve, interaction: Hiring::ApproveJobPostInteraction, category: :primary
    action :decline, interaction: Hiring::DeclineJobPostInteraction, modal: :centered
    action :apply, interaction: Hiring::ApplyToJobInteraction, category: :primary, modal: :centered
    action :renew, interaction: Hiring::RenewJobPostInteraction
    action :mark_filled, interaction: Hiring::MarkJobPostFilledInteraction, confirmation: "Mark this as filled? It will stop being listed."
    action :reopen, interaction: Hiring::ReopenJobPostInteraction
    action :archive, interaction: Hiring::ArchiveJobPostInteraction, category: :danger,
      confirmation: "Archive this post? It will be hidden and can't be edited."

    field :description, as: :markdown
    field :apply_url, as: :url, label: "Application link"
    field :pay, label: "Pay"
    field :timing, label: "Duration"
    field :type_label, label: "Type"

    display :status, as: :badge
    column :status, as: :badge
    column :expires_at, as: :date, label: "Expires"
    display :published_at, as: :date, label: "Published"
    display :expires_at, as: :date, label: "Expires"
    display :description, wrapper: {class: "col-span-full"}

    input :title, placeholder: "e.g. Senior Backend Engineer, or Landing page for a bakery"
    # Changing the type re-renders the form: timing fields show for gigs,
    # contracts and internships, and internships can be marked unpaid.
    input :employment_type, label: "Type", as: :select, pre_submit: true,
      choices: ::Hiring::JobPost::TYPE_LABELS.map { |value, label| [label, value] }
    input :duration, placeholder: "e.g. 2 weeks, 3 months", hint: "Roughly how long the work lasts.",
      condition: -> { object.time_bound? }
    input :starts_on, label: "Start date", hint: "Leave blank for \"as soon as possible\".",
      condition: -> { object.time_bound? }
    input :paid, as: :toggle, label: "This internship is paid", pre_submit: true,
      condition: -> { object.internship? }
    input :pay_period, label: "Pay is", as: :select,
      choices: ::Hiring::JobPost::PAY_PERIOD_LABELS.map { |value, label| [label.capitalize, value] },
      condition: -> { object.paid? }
    input :remote_ok, as: :toggle, label: "Remote OK"
    input :accepts_applications, as: :toggle, label: "Accept applications here",
      hint: "Developers apply with their profile. You review them under Applicants."
    input :apply_url, placeholder: "https://", hint: "Or send people to your own careers page. You can use both."
    input :visibility, as: :select, label: "Who can see this post",
      choices: [["Everyone: public jobs board, shareable link", "everyone"], ["Signed-in members only", "members"]]
    display :visibility, label: "Visible to"
    input :salary_min, label: "From", condition: -> { object.paid? }
    input :salary_max, label: "To", hint: "Leave blank for a single amount.", condition: -> { object.paid? }
    input :salary_currency, label: "Currency", hint: "3-letter code, e.g. USD, GHS, NGN", condition: -> { object.paid? }

    search do |scope, query|
      scope.where("hiring_job_posts.title LIKE :q OR hiring_job_posts.description LIKE :q", q: "%#{query}%")
    end

    default_sort :created_at, :desc

    form_layout do
      section :role, :title, :employment_type, :seniority, label: "What you're posting", columns: 3
      section :description, :description, label: "Description"
      # Hidden as a whole for permanent roles; hiding only its fields would
      # leave an empty heading behind.
      section :timing, :duration, :starts_on, label: "Timing", columns: 2,
        condition: -> { object.time_bound? }
      section :location, :remote_ok, :city, :country, label: "Location", columns: 3
      section :pay, :paid, :pay_period, :salary_min, :salary_max, :salary_currency, label: "Pay",
        description: "Optional, but posts that list pay get more applicants.", columns: 3
      section :applying, :accepts_applications, :apply_url, label: "How to apply", columns: 2
      section :visibility, :visibility, label: "Visibility"
      ungrouped label: "Other"
    end
  end
end
