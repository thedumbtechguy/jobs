# Public landing page. Shows only developers who opted into the directory
# (`listed`), and never their contact details.
class HomeController < ApplicationController
  def index
    listed = Developers::Profile.listed
    @stats = {
      developers: listed.count,
      companies: Company.count,
      open_jobs: Hiring::JobPost.active.count
    }
    @developers = listed.includes(profile_skills: :skill).order(created_at: :desc).limit(6)
    @jobs = Hiring::JobPost.active.includes(:company).newest.limit(5)
    @top_skills = Skill.joins(profile_skills: :profile).merge(listed)
      .group(:name).order(Arel.sql("COUNT(*) DESC"), :name).limit(16).count
  end
end
