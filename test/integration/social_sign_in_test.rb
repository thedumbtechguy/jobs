require "test_helper"

class SocialSignInTest < ActionDispatch::IntegrationTest
  include AccountsTestHelper

  setup { OmniAuth.config.test_mode = true }

  teardown do
    OmniAuth.config.mock_auth.delete(:google)
    OmniAuth.config.mock_auth.delete(:github)
    OmniAuth.config.test_mode = false
  end

  test "login and sign-up pages offer Google and GitHub" do
    get "/users/login"
    assert_select "form[action='/users/auth/google'] button", text: /Continue with Google/
    assert_select "form[action='/users/auth/github'] button", text: /Continue with GitHub/

    get "/users/create-account"
    assert_select "form[action='/users/auth/github']"
  end

  test "signing up with GitHub creates a verified account and prefills onboarding" do
    mock(:github, uid: "42", email: "octo@example.com",
      info: {name: "Octo Cat", nickname: "octocat", urls: {"GitHub" => "https://github.com/octocat"}})

    assert_difference -> { User.count } => 1, -> { User::Identity.count } => 1 do
      sign_in_with(:github)
    end

    user = User.find_by!(email: "octo@example.com")
    assert user.verified?
    assert_equal %w[github 42], [user.identities.sole.provider, user.identities.sole.uid]

    follow_redirect! while response.redirect?
    assert_equal "/onboarding", path
    assert_select "input[value='Octo Cat']"
    assert_select "input[value='octocat']"

    post "/onboarding", params: {onboarding: {developer: "1", name: "Octo Cat", handle: "octocat", hiring: "0"}}
    assert_equal "https://github.com/octocat", user.reload.developer_profile.github_url
  end

  test "Google sign-in links to an existing account with the same verified email" do
    user = create_user!(email: "ada@example.com")
    mock(:google, uid: "g-1", email: "ada@example.com", info: {name: "Ada"}, extra: {raw_info: {email_verified: true}})

    assert_no_difference -> { User.count } do
      sign_in_with(:google)
    end
    assert_equal user.id, User::Identity.find_by!(provider: "google", uid: "g-1").user_id
  end

  test "an unverified Google email is refused" do
    create_user!(email: "victim@example.com")
    mock(:google, uid: "g-2", email: "victim@example.com", extra: {raw_info: {email_verified: false}})

    assert_no_difference -> { User::Identity.count } do
      sign_in_with(:google)
    end
    assert_redirected_to "/users/login"
  end

  private

  def mock(provider, uid:, email:, info: {}, extra: {})
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s, uid:, info: {email:}.merge(info), extra:
    )
  end

  # Request phase (POST, CSRF-checked) then the provider's callback.
  def sign_in_with(provider)
    post "/users/auth/#{provider}"
    follow_redirect!
  end
end
