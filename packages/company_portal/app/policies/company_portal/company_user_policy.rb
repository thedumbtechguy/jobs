class CompanyPortal::CompanyUserPolicy < ::ResourcePolicy
  include CompanyPortal::ResourcePolicy

  # Core actions

  # def create?
  #   true
  # end

  # def read?
  #   true
  # end

  # Core attributes

  def permitted_attributes_for_create
    []
  end

  def permitted_attributes_for_read
    []
  end

  # Associations

  def permitted_associations
    %i[]
  end
end
