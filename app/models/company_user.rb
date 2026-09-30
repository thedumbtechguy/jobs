class CompanyUser < ::ResourceRecord
  # add concerns above.

  # add constants above.
  enum :role, owner: 0, recruiter: 1

  # add enums above.

  # add model configurations above.

  belongs_to :company
  belongs_to :user
  # add belongs_to associations above.

  # add has_one associations above.

  # add has_many associations above.

  # add attachments above.

  # add scopes above.

  validates :role, presence: true
  validates :user, uniqueness: {scope: :company_id, message: "is already a member of this company"}
  # add validations above.

  # add callbacks above.

  # add delegations above.

  # add misc attribute macros above.

  # add methods above. add private methods below.
end
