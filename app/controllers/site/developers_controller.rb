module Site
  class DevelopersController < BaseController
    AVAILABILITY_FILTERS = %w[looking open].freeze

    def index
      scope = Developers::Profile.visible_to(current_user)
      @countries = scope.where.not(country: [nil, ""]).distinct.order(:country).pluck(:country)
      @skills = Skill.joins(profile_skills: :profile).merge(scope).distinct.order(:name)

      scope = scope.search(params[:q]) if params[:q].present?
      scope = scope.where(id: Developers::ProfileSkill.joins(:skill).where(skills: {slug: params[:skill]}).select(:profile_id)) if params[:skill].present?
      scope = scope.where(country: params[:country]) if params[:country].present?
      scope = scope.where(availability: params[:availability]) if AVAILABILITY_FILTERS.include?(params[:availability])
      scope = scope.where(remote_ok: true) if params[:remote] == "1"

      @developers = paginate(scope.includes(profile_skills: :skill).order(availability: :desc, updated_at: :desc))
    end

    def show
      @profile = Developers::Profile.find_by!(handle: params[:handle].to_s.downcase)
      raise ActiveRecord::RecordNotFound unless @profile.visible_to?(current_user)

      @experiences = @profile.experiences
      @profile_skills = @profile.profile_skills.includes(:skill).sort_by { |ps| [-(ps.years || 0), ps.skill.name] }
      @own = current_user && @profile.user_id == current_user.id
      # Gigs and jobs they've posted as themselves.
      @posts = Hiring::JobPost.visible_to(current_user).joins(:company).where(companies: {personal_owner_id: @profile.user_id}).newest.limit(5)
    end
  end
end
