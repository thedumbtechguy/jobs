Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"

  # Public site: developer directory, profiles, jobs and companies.
  scope module: :site do
    get "devs", to: "developers#index", as: :developers_directory
    get "@:handle", to: "developers#show", as: :developer_page, constraints: {handle: /[A-Za-z0-9_-]+/}
    get "jobs", to: "jobs#index", as: :public_jobs
    get "jobs/:id", to: "jobs#show", as: :public_job
    get "companies/:slug", to: "companies#show", as: :public_company
  end

  # Onboarding: users create a developer profile, a company, or both.
  resource :onboarding, only: %i[show create], controller: "onboarding"
  resource :company_setup, only: %i[new create], path: "setup/company"
  resource :developer_profile_setup, only: %i[new create], path: "setup/developer"
  constraints ManagementConstraint do
    mount RailsPulse::Engine, at: "/manage/pulse"
    mount Litestream::Engine, at: "/manage/litestream"
    mount SolidErrors::Engine, at: "/manage/errors"
    mount MissionControl::Jobs::Engine, at: "/manage/jobs"
  end

  # Welcome route (handled by invites package — replace with pu:saas:welcome for full onboarding)
  get "welcome", to: "invites/welcome#index"

  # Invitation welcome routes (shared across all invite flows)
  scope module: :invites do
    get "invitations/welcome", to: "welcome#index", as: :invites_welcome_check
    delete "invitations/welcome", to: "welcome#skip", as: :invites_welcome_skip
  end

  # Invitation routes for CompanyUserInvite
  scope module: :invites do
    get "company_user_invitations/:token", to: "company_user_invitations#show", as: :company_user_invitation
    post "company_user_invitations/:token/accept", to: "company_user_invitations#accept", as: :accept_company_user_invitation
    get "company_user_invitations/:token/signup", to: "company_user_invitations#signup", as: :company_user_invitation_signup
    post "company_user_invitations/:token/signup", to: "company_user_invitations#signup"
  end
end
