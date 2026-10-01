# == Schema Information
#
# Table name: hiring_job_applications
#
#  id          :integer          not null, primary key
#  cover_note  :text
#  status      :integer          default("submitted"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  job_post_id :integer          not null
#  profile_id  :integer          not null
#
# Indexes
#
#  index_hiring_job_applications_on_job_post_id                 (job_post_id)
#  index_hiring_job_applications_on_job_post_id_and_profile_id  (job_post_id,profile_id) UNIQUE
#  index_hiring_job_applications_on_profile_id                  (profile_id)
#
# Foreign Keys
#
#  job_post_id  (job_post_id => hiring_job_posts.id)
#  profile_id   (profile_id => developers_profiles.id)
#
require_relative "../hiring"

# A developer applying to a job through the app.
class Hiring::JobApplication < Hiring::ResourceRecord
  enum :status, {submitted: 0, reviewing: 1, shortlisted: 2, rejected: 3, hired: 4, withdrawn: 5}

  belongs_to :job_post, class_name: "Hiring::JobPost"
  belongs_to :profile, class_name: "Developers::Profile"
  has_one :company, through: :job_post

  scope :open, -> { where(status: %i[submitted reviewing shortlisted]) }

  validates :profile, uniqueness: {scope: :job_post_id, message: "has already applied to this job"}
  validates :cover_note, length: {maximum: 5_000}
  validate :job_accepts_applications, on: :create

  def to_label
    "#{profile.name} for #{job_post.title}"
  end

  def withdrawable? = submitted? || reviewing? || shortlisted?

  def withdraw!
    update!(status: :withdrawn)
  end

  private

  def job_accepts_applications
    return if job_post.nil?

    errors.add(:base, "This job isn't accepting applications here") unless job_post.accepts_applications? && job_post.active?
  end
end
