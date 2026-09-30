# Links between the portals (and to the main-app setup pages) that work from
# any context: main-app views, portal engines and Phlex components.
module PortalPathsHelper
  # Holds the app's mounted engine proxies (dashboard_portal, developer_portal, ...)
  # so the helpers below don't depend on the caller's routing context.
  class Routes
    include Rails.application.routes.url_helpers
    include Rails.application.routes.mounted_helpers

    def _routes_context = self
  end

  def self.routes
    Routes.new
  end

  def home_dashboard_path
    PortalPathsHelper.routes.dashboard_portal.root_path
  end

  def developer_portal_home_path(profile)
    PortalPathsHelper.routes.developer_portal.developers_profile_scoped_root_path(developers_profile_scoped: profile)
  end

  def company_portal_home_path(company)
    PortalPathsHelper.routes.company_portal.company_scoped_root_path(company_scoped: company)
  end

  def new_developer_profile_path
    Rails.application.routes.url_helpers.new_developer_profile_setup_path
  end

  def new_company_path
    Rails.application.routes.url_helpers.new_company_setup_path
  end
end
