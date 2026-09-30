module AccountsTestHelper
  def create_user!(email: "dev#{SecureRandom.hex(4)}@example.com")
    User.create!(email:, status: :verified, password_hash: BCrypt::Password.create("password123"))
  end

  def create_developer!(user: create_user!, **attributes)
    user.create_developer!(name: "Ada Lovelace", handle: "ada-#{SecureRandom.hex(3)}", **attributes)
  end

  # Logs in and follows the post-login redirects (/welcome checks for invites first).
  def login_user(user)
    login_as(user, portal: :user)
    follow_redirect! while response.redirect?
  end
end
