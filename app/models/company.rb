# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  city        :string
#  country     :string
#  description :text
#  name        :string           not null
#  slug        :string           not null
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_companies_on_name  (name) UNIQUE
#  index_companies_on_slug  (slug) UNIQUE
#
class Company < ::ResourceRecord
  # add concerns above.

  # add constants above.

  # add enums above.
  dynamic_path_parameter :slug

  # add model configurations above.

  # add belongs_to associations above.

  # add has_one associations above.
  has_many :company_users, dependent: :destroy
  has_many :users, through: :company_users
  has_many :company_user_invites, class_name: "Invites::CompanyUserInvite", dependent: :destroy

  # add has_many associations above.

  # add attachments above.
  scope :associated_with_user, ->(user) { joins(:company_users).where(company_users: {user_id: user.id}) }

  # add scopes above.

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
    format: {with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "may only contain lowercase letters, numbers and dashes"}
  # add validations above.

  before_validation { self.slug = name.to_s.parameterize if slug.blank? }
  # add callbacks above.

  # add delegations above.

  # add misc attribute macros above.

  # add methods above. add private methods below.
end
