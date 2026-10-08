module DashboardPortal
  # Which categories of email the signed-in user gets.
  class EmailSettingsController < PlutoniumController
    def show
    end

    def update
      enabled = params.fetch(:email_settings, {}).permit(categories: [])[:categories].to_a
      current_user.update_email_opt_outs!(EmailOptOut::CATEGORIES.keys - enabled)
      redirect_to email_settings_path, notice: "Email settings saved."
    end
  end
end
