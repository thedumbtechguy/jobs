Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
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
