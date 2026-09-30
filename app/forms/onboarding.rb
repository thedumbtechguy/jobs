# Onboarding for a new user. Every user gets their own Developer listing.
# Users who are hiring can also set up a company in the same step; they
# become its owner and keep their personal listing.
class Onboarding
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :handle, :string
  attribute :headline, :string
  attribute :city, :string
  attribute :country, :string
  attribute :hiring, :boolean, default: false
  attribute :company_name, :string
  attribute :company_website, :string

  attr_reader :user, :developer, :company

  def initialize(user:, **attributes)
    @user = user
    super(**attributes)
    self.handle ||= suggested_handle
  end

  def save
    @developer = user.build_developer(name:, handle:, headline:, city:, country:)
    @company = Company.new(name: company_name, website: company_website) if hiring

    return false unless records_valid?

    ActiveRecord::Base.transaction do
      developer.save!
      if company
        company.save!
        company.company_users.create!(user:, role: :owner)
      end
    end
    true
  end

  private

  COMPANY_ERROR_ATTRIBUTES = {name: :company_name, website: :company_website}.freeze

  def records_valid?
    developer_valid = developer.valid?
    company_valid = company.nil? || company.valid?

    developer.errors.each { |error| errors.import(error, attribute: error.attribute) }
    company&.errors&.each do |error|
      errors.import(error, attribute: COMPANY_ERROR_ATTRIBUTES.fetch(error.attribute, :base))
    end

    developer_valid && company_valid
  end

  def suggested_handle
    user.email.to_s.split("@").first.to_s.downcase.gsub(/[^a-z0-9_-]/, "-").squeeze("-").delete_prefix("-").delete_suffix("-").first(30)
  end
end
