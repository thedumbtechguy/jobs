# == Schema Information
#
# Table name: hiring_job_posts
#
#  id                   :integer          not null, primary key
#  accepts_applications :boolean          default(TRUE), not null
#  apply_url            :string
#  approved_at          :datetime
#  archived_at          :datetime
#  city                 :string
#  country              :string
#  description          :text             not null
#  employment_type      :integer          default("full_time"), not null
#  expires_at           :datetime
#  filled_at            :datetime
#  published_at         :datetime
#  remote_ok            :boolean          default(FALSE), not null
#  salary_currency      :string           default("USD"), not null
#  salary_max           :integer
#  salary_min           :integer
#  seniority            :integer
#  title                :string           not null
#  visibility           :integer          default("everyone"), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  company_id           :integer          not null
#
# Indexes
#
#  index_hiring_job_posts_on_company_id                   (company_id)
#  index_hiring_job_posts_on_published_at_and_expires_at  (published_at,expires_at)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
require_relative "../hiring"

# A job a company is hiring for. Lifecycle (from the old jobs app):
# draft -> published for VALIDITY_PERIOD -> expired (renewable), and it can be
# marked filled or archived at any point. Applications happen in the app,
# through an external link, or both.
#
# A company's first job is reviewed: until an admin approves one of its jobs
# the company isn't trusted, and publishing puts the job in review (hidden,
# admins emailed). Approval makes it live and trusts the company, so later
# jobs go live as soon as they're published.
class Hiring::JobPost < Hiring::ResourceRecord
  VALIDITY_PERIOD = ENV.fetch("JOB_VALIDITY_DAYS", 30).to_i.days

  enum :employment_type, {full_time: 0, part_time: 1, contract: 2, internship: 3}
  enum :seniority, {junior: 0, mid: 1, senior: 2, lead: 3, principal: 4}
  # Who can see the job on the public site. Applying always needs an account.
  enum :visibility, {members: 1, everyone: 2}, prefix: :visible_to

  # /jobs/42-senior-rails-engineer (the id is what's looked up).
  dynamic_path_parameter :title

  belongs_to :company
  has_many :job_applications, class_name: "Hiring::JobApplication", dependent: :destroy

  scope :published, -> { where.not(published_at: nil) }
  scope :approved, -> { published.where.not(approved_at: nil) }
  scope :active, -> { approved.where(filled_at: nil, archived_at: nil).where("expires_at > ?", Time.current) }
  scope :drafts, -> { where(published_at: nil, archived_at: nil) }
  scope :pending_review, -> { published.where(approved_at: nil, filled_at: nil, archived_at: nil) }
  scope :newest, -> { order(published_at: :desc, created_at: :desc) }
  # Active jobs a viewer may see: public ones for guests, all for members.
  scope :visible_to, ->(user) { user ? active : active.visible_to_everyone }

  scope :search, ->(query) {
    term = "%#{sanitize_sql_like(query.to_s.strip.downcase)}%"
    joins(:company).where(
      "LOWER(hiring_job_posts.title) LIKE :t OR LOWER(hiring_job_posts.description) LIKE :t OR LOWER(companies.name) LIKE :t " \
      "OR LOWER(hiring_job_posts.city) LIKE :t OR LOWER(hiring_job_posts.country) LIKE :t", t: term
    )
  }

  validates :title, presence: true
  validates :description, presence: true
  validates :employment_type, presence: true
  validates :salary_currency, presence: true, length: {is: 3}
  validates :salary_min, :salary_max, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :salary_max, comparison: {greater_than_or_equal_to: :salary_min}, allow_nil: true, if: :salary_min
  validates :apply_url, **WebUrl.validation
  validate :has_a_way_to_apply

  normalizes :salary_currency, with: ->(currency) { currency.strip.upcase }

  def status
    if archived_at then :archived
    elsif filled_at then :filled
    elsif published_at.nil? then :draft
    elsif approved_at.nil? then :pending_review
    elsif expires_at&.past? then :expired
    else :active
    end
  end

  def active? = status == :active

  def visible_to?(user) = active? && (visible_to_everyone? || user.present?)

  def publishable? = status == :draft

  def pending_review? = status == :pending_review

  def renewable? = status == :expired

  def fillable? = %i[active expired].include?(status)

  # Goes live straight away for trusted companies; otherwise waits for review.
  def publish!
    if company.jobs_trusted?
      update!(published_at: Time.current, approved_at: Time.current, expires_at: VALIDITY_PERIOD.from_now)
    else
      update!(published_at: Time.current, approved_at: nil, expires_at: nil)
      Hiring::JobReviewMailer.with(job_post: self).review_requested.deliver_later
    end
  end

  # Admin approval: the job goes live for the full period and the company is
  # trusted from now on.
  def approve!
    transaction do
      update!(approved_at: Time.current, published_at: Time.current, expires_at: VALIDITY_PERIOD.from_now)
      company.update!(jobs_trusted_at: Time.current) unless company.jobs_trusted?
    end
    Hiring::JobReviewMailer.with(job_post: self).approved.deliver_later
  end

  # Admin sends the job back to draft with a reason for the company.
  def decline!(reason)
    update!(published_at: nil, approved_at: nil, expires_at: nil)
    Hiring::JobReviewMailer.with(job_post: self, reason:).declined.deliver_later
  end

  def renew!
    update!(expires_at: VALIDITY_PERIOD.from_now)
  end

  def mark_filled!
    update!(filled_at: Time.current)
  end

  def reopen!
    update!(filled_at: nil, expires_at: [expires_at, VALIDITY_PERIOD.from_now].compact.max)
  end

  def archive!
    update!(archived_at: Time.current)
  end

  def location
    parts = [city, country].compact_blank.join(", ")
    remote_ok? ? [parts.presence, "Remote"].compact.join(" · ") : parts
  end

  def salary_range
    return if salary_min.nil? && salary_max.nil?

    [salary_min, salary_max].compact.uniq.map { |amount| ActiveSupport::NumberHelper.number_to_delimited(amount) }.join(" – ") + " #{salary_currency}"
  end

  def to_label
    "#{title} at #{company.name}"
  end

  private

  def has_a_way_to_apply
    return if accepts_applications? || apply_url.present?

    errors.add(:base, "Accept applications here, add an application link, or both")
  end
end
