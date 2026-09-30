# Links into the entity-scoped portals from anywhere in the app.
module PortalPathsHelper
  def developer_portal_home_path(profile)
    developer_portal.developers_profile_scoped_root_path(developers_profile_scoped: profile)
  end

  def company_portal_home_path(company)
    company_portal.company_scoped_root_path(company_scoped: company)
  end
end
