module Site
  class CompaniesController < BaseController
    def show
      @company = Company.find_by!(slug: params[:slug])
      @jobs = Hiring::JobPost.visible_to(current_user).where(company: @company).newest
    end
  end
end
