# Onboarding for a new user. Users pick what they are here for: a developer
# profile, a company (to hire), or both. At least one is required; the other
# can be added later from the dashboard.
class Onboarding
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :developer, :boolean, default: true
  attribute :name, :string
  attribute :handle, :string
  attribute :headline, :string
  attribute :city, :string
  attribute :country, :string

  attribute :hiring, :boolean, default: false
  attribute :company_name, :string
  attribute :company_website, :string

  validate :developer_or_hiring

  attr_reader :user, :profile, :company

  def initialize(user:, **attributes)
    @user = user
    super(**attributes)
    self.handle ||= suggested_handle
  end

  def save
    @profile = user.build_developer_profile(name:, handle:, headline:, city:, country:) if developer
    @company = Company.new(name: company_name, website: company_website) if hiring

    return false unless valid? & records_valid?

    ActiveRecord::Base.transaction do
      profile&.save!
      if company
        company.save!
        company.company_users.create!(user:, role: :owner)
      end
    end
    true
  end

  private

  COMPANY_ERROR_ATTRIBUTES = {name: :company_name, website: :company_website}.freeze

  def developer_or_hiring
    errors.add(:base, "Choose a developer profile, a company, or both") unless developer || hiring
  end

  def records_valid?
    profile_valid = profile.nil? || profile.valid?
    company_valid = company.nil? || company.valid?

    profile&.errors&.each { |error| errors.import(error, attribute: error.attribute) }
    company&.errors&.each do |error|
      errors.import(error, attribute: COMPANY_ERROR_ATTRIBUTES.fetch(error.attribute, :base))
    end

    profile_valid && company_valid
  end

  def suggested_handle
    user.email.to_s.split("@").first.to_s.downcase.gsub(/[^a-z0-9_-]/, "-").squeeze("-").delete_prefix("-").delete_suffix("-").first(30)
  end
end
