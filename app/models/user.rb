# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string           not null
#  password_hash :string
#  status        :integer          default("unverified"), not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE WHERE status IN (1, 2)
#
class User < ResourceRecord
  include Rodauth::Rails.model(:user)

  # add concerns above.

  # add constants above.

  enum :status, unverified: 1, verified: 2, closed: 3
  # add enums above.

  # add model configurations above.

  # add belongs_to associations above.

  has_one :developer_profile, class_name: "Developers::Profile", dependent: :destroy
  # add has_one associations above.
  has_many :company_users, dependent: :destroy
  has_many :companies, through: :company_users

  # add has_many associations above.

  # add attachments above.

  # add scopes above.

  validates :email, presence: true
  # add validations above.

  # add callbacks above.

  # add delegations above.

  # add misc attribute macros above.

  def to_label
    email
  end

  # Onboarded users have a developer profile, a company, or both.
  def onboarded?
    developer_profile.present? || company_users.exists?
  end

  # add methods above. add private methods below.
end
