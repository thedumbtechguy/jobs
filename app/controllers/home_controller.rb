# Public landing page. Shows only profiles and jobs the viewer may see, and
# never contact details.
class HomeController < Site::BaseController
  def index
    listed = Developers::Profile.visible_to(current_user)
    @stats = {
      developers: listed.count,
      companies: Company.count,
      open_jobs: Hiring::JobPost.visible_to(current_user).count
    }
    @developers = listed.includes(profile_skills: :skill).order(created_at: :desc).limit(6)
    @jobs = Hiring::JobPost.visible_to(current_user).includes(:company).newest.limit(5)
    @top_skills = Skill.joins(profile_skills: :profile).merge(listed)
      .group(:name, :slug).order(Arel.sql("COUNT(*) DESC"), :name).limit(16).count
  end
end
