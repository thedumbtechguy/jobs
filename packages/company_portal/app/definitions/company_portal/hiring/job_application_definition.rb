module CompanyPortal
  module Hiring
    class JobApplicationDefinition < ::Hiring::JobApplicationDefinition
      index_page_title "Applicants"
      index_page_description "Everyone who applied to your jobs through Dev Registry."

      scope :open
    end
  end
end
