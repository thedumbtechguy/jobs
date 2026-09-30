module Developers
  class ProfileDefinition < Developers::ResourceDefinition
    show_page_title "Profile"
    edit_page_title "Edit profile"
    modal false
    submit_and_continue false

    field :bio, as: :markdown
    field :contact_email, as: :email, label: "Contact email"
    field :phone, as: :phone
    field :website_url, as: :url, label: "Website"
    field :github_url, as: :url, label: "GitHub"
    field :linkedin_url, as: :url, label: "LinkedIn"
    field :x_url, as: :url, label: "X (Twitter)"
    field :years_experience, label: "Years of experience"
    field :remote_ok, label: "Open to remote work"
    field :open_to_relocation, label: "Open to relocating"
    field :listed, label: "Listed in the directory"

    input :handle, hint: "Your public page will be at /@handle"
    input :headline, placeholder: "e.g. Backend engineer, Rails and Postgres"
    input :bio, hint: "Markdown supported."
    input :timezone, as: :select, choices: -> { ActiveSupport::TimeZone.all.map(&:name) }
    input :remote_ok, as: :toggle
    input :open_to_relocation, as: :toggle
    input :listed, as: :toggle, hint: "Turn off to hide your profile from the directory"
    input :contact_visibility, hint: "Who can see your email and phone number"
    input :github_url, placeholder: "https://github.com/you"
    input :linkedin_url, placeholder: "https://linkedin.com/in/you"
    input :website_url, placeholder: "https://"
    input :x_url, placeholder: "https://x.com/you"

    display :bio, wrapper: {class: "col-span-full"}

    form_layout do
      section :about, :name, :handle, :headline, label: "About you", columns: 2
      section :bio, :bio, label: "Bio", description: "A few sentences about what you do and what you're looking for."
      section :work, :availability, :seniority, :years_experience, label: "Work", description: "Let companies know if you're looking.", columns: 3
      section :location, :city, :region, :country, :timezone, :remote_ok, :open_to_relocation, label: "Location", columns: 2
      section :contact, :contact_email, :phone, :website_url, :github_url, :linkedin_url, :x_url, label: "Contact & links", columns: 2
      section :privacy, :contact_visibility, :listed, label: "Privacy", columns: 2
      ungrouped label: "Other"
    end

    display_layout do
      section :about, :name, :handle, :headline, :bio, label: "About"
      section :work, :availability, :seniority, :years_experience, label: "Work"
      section :location, :city, :region, :country, :timezone, :remote_ok, :open_to_relocation, label: "Location"
      section :contact, :contact_email, :phone, :website_url, :github_url, :linkedin_url, :x_url, label: "Contact & links"
      section :privacy, :contact_visibility, :listed, label: "Privacy"
      ungrouped label: "Other"
    end
  end
end
