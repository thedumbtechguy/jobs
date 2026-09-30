class CompanyPortal::CompanyPolicy < ::CompanyPolicy
  include CompanyPortal::ResourcePolicy

  def update?
    current_membership&.owner?
  end

  def destroy?
    false
  end

  def permitted_attributes_for_read
    [:name]
  end

  def permitted_attributes_for_update
    [:name]
  end

  def permitted_associations
    []
  end
end
