# Emails people can turn off by category (see EmailOptOut::CATEGORIES). Each
# goes to one user and is skipped if they've opted out. Everyone else gets an
# unsubscribe link in the footer and the one-click headers mail clients use.
module CategorizedEmail
  private

  def categorized_mail(category, to:, **)
    return unless to.wants_email?(category)

    @email_category = EmailOptOut::CATEGORIES.fetch(category.to_s)
    @unsubscribe_url = unsubscribe_url(token: EmailOptOut.token_for(to, category))
    @email_settings_url = absolute_url(PortalPathsHelper.routes.dashboard_portal.email_settings_path)
    headers["List-Unsubscribe"] = "<#{@unsubscribe_url}>"
    headers["List-Unsubscribe-Post"] = "List-Unsubscribe=One-Click"
    mail(to: to.email, **)
  end
end
