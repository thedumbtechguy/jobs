class CompanyDefinition < ::ResourceDefinition
  action :invite_user, interaction: Company::InviteUserInteraction, category: :secondary
end
