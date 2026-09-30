class CompanyDefinition < ::ResourceDefinition
  action :invite_user, interaction: Company::InviteUserInteraction, category: :secondary

  modal false
  submit_and_continue false

  field :description, as: :markdown
  field :website, as: :url

  input :slug, hint: "Used in your company's URLs"
  input :website, placeholder: "https://"
  display :description, wrapper: {class: "col-span-full"}

  form_layout do
    section :company, :name, :slug, :website, label: "Company", columns: 2
    section :about, :description, label: "About"
    section :location, :city, :country, label: "Location", columns: 2
    ungrouped label: "Other"
  end
end
