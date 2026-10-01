require_relative "../network"

# One developer following another. Two follows in opposite directions make a
# connection (see Developers::Profile#connections); there's no request or
# accept state to keep in sync.
class Network::Follow < Network::ResourceRecord
  # add concerns above.

  # add constants above.

  # add enums above.

  # add model configurations above.

  belongs_to :follower, class_name: "Developers::Profile"
  belongs_to :followee, class_name: "Developers::Profile"
  # add belongs_to associations above.

  # add has_one associations above.

  # add has_many associations above.

  # add attachments above.

  scope :newest, -> { order(created_at: :desc) }
  # add scopes above.

  validates :followee, uniqueness: {scope: :follower_id, message: "is already followed"}
  validate :not_following_self
  # add validations above.

  after_create_commit :notify_followee
  # add callbacks above.

  # add delegations above.

  # add misc attribute macros above.

  def to_label
    "#{follower&.name} follows #{followee&.name}"
  end

  # The follow in the other direction exists, so the two are connected.
  def mutual?
    Network::Follow.exists?(follower_id: followee_id, followee_id: follower_id)
  end

  # add methods above. add private methods below.

  private

  def not_following_self
    errors.add(:followee, "can't be yourself") if follower_id.present? && follower_id == followee_id
  end

  # Unfollowing and following again shouldn't email the same person twice, so
  # each pair gets at most one email a week.
  def notify_followee
    key = "network/follow-email/#{follower_id}/#{followee_id}"
    return if Rails.cache.exist?(key)

    Rails.cache.write(key, true, expires_in: 1.week)
    Network::FollowMailer.with(follow: self).followed.deliver_later
  end
end
