DeveloperPortal::Engine.routes.draw do
  root to: "dashboard#index"
  register_resource ::Developers::Profile, singular: true
  register_resource ::Developers::Experience
  register_resource ::Developers::ProfileSkill
  register_resource ::Hiring::JobPost, associations: []
  register_resource ::Hiring::JobApplication

  # register resources above.

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end

# mount our app
Rails.application.routes.draw do
  constraints Rodauth::Rails.authenticate(:user) do
    mount DeveloperPortal::Engine, at: "/developer"
  end
end
