# Sends signed-in users who have not finished onboarding (no Developer
# listing yet) to /onboarding before they can use a portal.
module RequiresOnboarding
  extend ActiveSupport::Concern

  included do
    before_action :require_onboarding
  end

  private

  def require_onboarding
    return if current_user.nil? || current_user.developer.present?

    redirect_to main_app.onboarding_path
  end
end
