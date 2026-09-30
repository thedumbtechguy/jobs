class Company < ::ResourceRecord
  # add concerns above.

  # add constants above.

  # add enums above.
  dynamic_path_parameter :name

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
  validates :slug, presence: true
  validates :website, presence: true
  validates :description, presence: true
  validates :city, presence: true
  validates :country, presence: true
  # add validations above.

  # add callbacks above.

  # add delegations above.

  # add misc attribute macros above.

  # add methods above. add private methods below.
end
