class CompanyPolicy < ::ResourcePolicy
  # Core actions

  # def create?
  #   true
  # end

  # def read?
  #   true
  # end

  def invite_user?
    current_membership&.owner?
  end

  # Core attributes

  def permitted_attributes_for_create
    [:name, :slug, :website, :description, :city, :country]
  end

  def permitted_attributes_for_read
    [:name, :slug, :website, :description, :city, :country]
  end

  # Associations

  def permitted_associations
    %i[]
  end
end
