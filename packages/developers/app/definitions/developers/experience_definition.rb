module Developers
  class ExperienceDefinition < Developers::ResourceDefinition
    field :description, as: :markdown

    input :ended_on, hint: "Leave blank if this is your current role"
  end
end
