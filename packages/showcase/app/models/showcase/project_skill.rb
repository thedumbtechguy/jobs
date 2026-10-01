require_relative "../showcase"

class Showcase::ProjectSkill < Showcase::ResourceRecord
  belongs_to :project, class_name: "Showcase::Project"
  belongs_to :skill

  validates :skill, uniqueness: {scope: :project_id}
end
