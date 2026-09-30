class DeveloperPolicy < ::ResourcePolicy
  # Core actions

  # def create?
  #   true
  # end

  # def read?
  #   true
  # end

  # Core attributes

  def permitted_attributes_for_create
    [:user, :handle, :name, :headline, :bio, :city, :region, :country, :timezone, :remote_ok, :open_to_relocation, :contact_email, :phone, :website_url, :github_url, :linkedin_url, :x_url, :availability, :seniority, :years_experience, :contact_visibility, :listed]
  end

  def permitted_attributes_for_read
    [:user, :handle, :name, :headline, :bio, :city, :region, :country, :timezone, :remote_ok, :open_to_relocation, :contact_email, :phone, :website_url, :github_url, :linkedin_url, :x_url, :availability, :seniority, :years_experience, :contact_visibility, :listed]
  end

  # Associations

  def permitted_associations
    %i[]
  end
end
