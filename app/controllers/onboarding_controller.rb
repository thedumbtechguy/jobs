class OnboardingController < ApplicationController
  include UserAuthenticated

  before_action :redirect_if_onboarded

  def show
    @onboarding = Onboarding.new(user: current_user)
  end

  def create
    @onboarding = Onboarding.new(user: current_user, **onboarding_params)

    if @onboarding.save
      if @onboarding.company
        redirect_to company_portal_path(@onboarding.company), notice: "Welcome! Your listing and #{@onboarding.company.name} are ready."
      else
        redirect_to dashboard_portal.root_path, notice: "Welcome! Your listing is ready."
      end
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def redirect_if_onboarded
    redirect_to dashboard_portal.root_path if current_user.developer.present?
  end

  def onboarding_params
    params.require(:onboarding)
      .permit(:name, :handle, :headline, :city, :country, :hiring, :company_name, :company_website)
      .to_h.symbolize_keys
  end
end
