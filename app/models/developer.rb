# == Schema Information
#
# Table name: developers
#
#  id                 :integer          not null, primary key
#  availability       :integer          default("open"), not null
#  bio                :text
#  city               :string
#  contact_email      :string
#  contact_visibility :integer          default("members"), not null
#  country            :string
#  github_url         :string
#  handle             :string           not null
#  headline           :string
#  linkedin_url       :string
#  listed             :boolean          default(TRUE), not null
#  name               :string           not null
#  open_to_relocation :boolean          default(FALSE), not null
#  phone              :string
#  region             :string
#  remote_ok          :boolean          default(TRUE), not null
#  seniority          :integer
#  timezone           :string
#  website_url        :string
#  x_url              :string
#  years_experience   :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer          not null
#
# Indexes
#
#  index_developers_on_country                  (country)
#  index_developers_on_handle                   (handle) UNIQUE
#  index_developers_on_listed_and_availability  (listed,availability)
#  index_developers_on_user_id                  (user_id) UNIQUE
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Developer < ::ResourceRecord
  # add concerns above.

  HANDLE_FORMAT = /\A[a-z0-9][a-z0-9_-]{1,28}[a-z0-9]\z/
  RESERVED_HANDLES = %w[
    admin admins api company companies dashboard devs developers help jobs login
    logout manage onboarding projects settings signup support users welcome
  ].freeze

  # add constants above.

  enum :availability, {not_looking: 0, open: 1, looking: 2}
  enum :seniority, {junior: 0, mid: 1, senior: 2, lead: 3, principal: 4}
  # Who may see contact_email and phone. Enforced in DeveloperPolicy.
  enum :contact_visibility, {everyone: 0, members: 1, connections: 2}, prefix: :contact_visible_to

  # add enums above.

  # add model configurations above.

  belongs_to :user
  # add belongs_to associations above.

  # add has_one associations above.

  # add has_many associations above.

  # add attachments above.

  scope :listed, -> { where(listed: true) }

  # add scopes above.

  validates :handle, presence: true, uniqueness: true,
    format: {with: HANDLE_FORMAT, message: "must be 3-30 lowercase letters, numbers, dashes or underscores"},
    exclusion: {in: RESERVED_HANDLES, message: "is reserved"}
  validates :user, uniqueness: true
  validates :name, presence: true
  validates :remote_ok, inclusion: {in: [true, false]}
  validates :open_to_relocation, inclusion: {in: [true, false]}
  validates :availability, presence: true
  validates :contact_email, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_blank: true
  validates :years_experience, numericality: {only_integer: true, in: 0..60}, allow_nil: true
  validates :contact_visibility, presence: true
  validates :listed, inclusion: {in: [true, false]}
  # add validations above.

  normalizes :handle, with: ->(handle) { handle.strip.downcase.delete_prefix("@") }

  # add callbacks above.

  # add delegations above.

  # add misc attribute macros above.

  def to_label
    name
  end

  def to_param
    handle
  end

  def location
    [city, region, country].compact_blank.join(", ")
  end

  # add methods above. add private methods below.
end
