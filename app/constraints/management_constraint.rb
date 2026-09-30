# frozen_string_literal: true

# Gates the management engines mounted in config/routes.rb.
class ManagementConstraint
  # Rodauth (redirects to the login page when signed out):
  #   AUTHENTICATE = Rodauth::Rails.authenticate(:admin)
  #
  #   def self.matches?(request)
  #     AUTHENTICATE.call(request)
  #   end

  def self.matches?(request)
    false # TODO: Implement authentication
    # Examples:
    #   Devise:     request.env["warden"].user(:admin).present?
    #   Custom:     request.session[:admin_id].present?
    #   HTTP Basic: authenticate_with_http_basic(request)
  end

  # HTTP Basic Auth example:
  # def self.authenticate_with_http_basic(request)
  #   auth = Rack::Auth::Basic::Request.new(request.env)
  #   return false unless auth.provided? && auth.basic?
  #
  #   username, password = auth.credentials
  #   ActiveSupport::SecurityUtils.secure_compare(username, ENV["ADMIN_USERNAME"]) &&
  #     ActiveSupport::SecurityUtils.secure_compare(password, ENV["ADMIN_PASSWORD"])
  # end
end
