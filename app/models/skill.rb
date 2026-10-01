# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_skills_on_name  (name) UNIQUE
#  index_skills_on_slug  (slug) UNIQUE
#
class Skill < ::ResourceRecord
  # add concerns above.

  # add constants above.

  # add enums above.

  path_parameter :slug

  # add model configurations above.

  # add belongs_to associations above.

  # add has_one associations above.

  has_many :profile_skills, class_name: "Developers::ProfileSkill", dependent: :restrict_with_error
  # add has_many associations above.

  # add attachments above.

  # add scopes above.

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true
  # add validations above.

  normalizes :name, with: ->(name) { name.squish }
  before_validation { self.slug = name.to_s.parameterize if slug.blank? }

  # add callbacks above.

  # add delegations above.

  # add misc attribute macros above.

  def to_label
    name
  end

  # add methods above. add private methods below.
end
