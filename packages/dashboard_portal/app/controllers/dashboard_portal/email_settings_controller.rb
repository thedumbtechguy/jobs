module DashboardPortal
  # Which categories of email the signed-in user gets.
  class EmailSettingsController < PlutoniumController
    def show
    end

    def update
      enabled = params.fetch(:email_settings, {}).permit(categories: [])[:categories].to_a
      current_user.update_opt_outs!(NotificationOptOut::CATEGORIES.keys - enabled, via: :email)
      redirect_to email_settings_path, notice: "Email settings saved."
    end
  end
end
