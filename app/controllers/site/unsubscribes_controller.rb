# Unsubscribe links from categorised emails. Opening the link only asks:
# link scanners follow GETs, so turning emails off takes a POST, which is also
# what mail clients send for one-click unsubscribe (with no CSRF token).
module Site
  class UnsubscribesController < BaseController
    skip_forgery_protection only: :create
    before_action :resolve_token

    def show
    end

    def create
      @user.opt_out_of_email!(@category)
      render :show
    end

    private

    def resolve_token
      @user, @category = EmailOptOut.resolve(params[:token])
      raise ActiveRecord::RecordNotFound unless @user
    end
  end
end
