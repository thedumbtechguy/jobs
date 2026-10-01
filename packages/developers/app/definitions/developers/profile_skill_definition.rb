module Developers
  class ProfileSkillDefinition < Developers::ResourceDefinition
    index_page_title "Skills"
    index_page_description "Languages, frameworks and tools you work with."
    modal :centered

    input :years, hint: "Years of experience with this skill"

    field :endorsements_count, label: "Endorsements"

    sort :years
    sort :endorsements_count
    default_sort { |scope| scope.joins(:skill).order("skills.name") }
  end
end
