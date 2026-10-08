# == Schema Information
#
# Table name: email_opt_outs
#
#  id         :integer          not null, primary key
#  category   :string           not null
#  created_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_email_opt_outs_on_user_id_and_category  (user_id,category) UNIQUE
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
# A category of email a user has turned off. Every category is on until the
# user opts out, from the email settings page or an unsubscribe link.
class EmailOptOut < ApplicationRecord
  CATEGORIES = {
    "network" => {label: "Network activity", description: "When someone follows you or you become connected."},
    "applications" => {label: "Job applications", description: "New applicants on your company's jobs, and updates on jobs you've applied to."},
    "project_credits" => {label: "Project credits", description: "When someone credits you on a project, or confirms a credit you gave them."}
  }.freeze

  belongs_to :user

  validates :category, inclusion: {in: CATEGORIES.keys}

  # Unsubscribe links carry the user and category in a signed token. It never
  # expires, so links in old emails keep working.
  def self.token_for(user, category)
    verifier.generate([user.id, category.to_s], purpose: :unsubscribe)
  end

  # The [user, category] a token was made for, or nil.
  def self.resolve(token)
    user_id, category = verifier.verified(token, purpose: :unsubscribe)
    user = User.find_by(id: user_id) if CATEGORIES.key?(category)
    [user, category] if user
  end

  # URL-safe, since the token goes in the link's path.
  def self.verifier
    @verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.key_generator.generate_key("email_opt_out"), url_safe: true)
  end
  private_class_method :verifier
end
