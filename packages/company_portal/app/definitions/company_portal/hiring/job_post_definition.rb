module CompanyPortal
  module Hiring
    class JobPostDefinition < ::Hiring::JobPostDefinition
      index_page_description "Post roles, then publish them when they're ready."

      scope :active
      scope :drafts
    end
  end
end
