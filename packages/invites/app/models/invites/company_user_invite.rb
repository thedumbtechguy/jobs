# frozen_string_literal: true

module Invites
  class CompanyUserInvite < Invites::ResourceRecord
    include Plutonium::Invites::Concerns::InviteToken

    enum :role, CompanyUser.roles

    encrypts :token, deterministic: true

    belongs_to :company, class_name: "Company"
    belongs_to :invited_by, polymorphic: true
    belongs_to :user, optional: true
    belongs_to :invitable, polymorphic: true, optional: true

    validates :role, presence: true

    # Implement required methods from InviteToken concern

    def invitation_mailer
      Invites::CompanyUserInviteMailer
    end

    def enforce_domain
      nil
    end

    def create_membership_for(user)
      CompanyUser.create!(company: company, user: user, role: role)
    end

    # Alias for InviteToken concern compatibility (used by views/mailers
    # that read `@invite.entity.to_label`).
    alias_method :entity, :company
  end
end
