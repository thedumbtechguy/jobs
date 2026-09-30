module Developers
  class ProfileDefinition < Developers::ResourceDefinition
    field :bio, as: :markdown
    field :contact_email, as: :email
    field :phone, as: :phone
    field :website_url, as: :url
    field :github_url, as: :url
    field :linkedin_url, as: :url
    field :x_url, as: :url

    input :handle, hint: "Your public page will be at /@handle"
    input :listed, hint: "Show me in the developer directory"
    input :contact_visibility, hint: "Who can see your email and phone number"
  end
end
