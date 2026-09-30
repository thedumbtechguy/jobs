# For main-app pages that need a signed-in user (outside the portals).
module UserAuthenticated
  extend ActiveSupport::Concern

  included do
    include Plutonium::Auth::Rodauth(:user)

    before_action { rodauth(:user).require_account }
    layout "onboarding"
  end

  private

  def company_portal_path(company)
    company_portal.company_scoped_root_path(company_scoped: company)
  end
end
