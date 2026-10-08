require "test_helper"

class SlackConnectionTest < ActionDispatch::IntegrationTest
  include Plutonium::Testing::AuthHelpers
  include AccountsTestHelper

  setup do
    OmniAuth.config.test_mode = true
    @user = create_profile!.user
  end

  teardown do
    OmniAuth.config.mock_auth.delete(:slack)
    OmniAuth.config.test_mode = false
  end

  test "connecting Slack while signed in links it to you and turns email off" do
    login_user(@user)
    mock_slack(uid: "U123", email: "different@example.com")

    assert_no_difference -> { User.count } do
      post "/users/auth/slack"
      follow_redirect!
    end

    assert_equal "U123", @user.reload.slack_identity.uid
    assert_not @user.wants_notification?(:applications, via: :email)
    follow_redirect! while response.redirect?
    assert_match "Slack connected", response.body
  end

  test "a Slack account linked to someone else can't be connected" do
    other = create_user!
    other.identities.create!(provider: "slack", uid: "U123")
    login_user(@user)
    mock_slack(uid: "U123", email: @user.email)

    post "/users/auth/slack"
    follow_redirect!

    assert_nil @user.reload.slack_identity
    assert_equal other.id, User::Identity.find_by!(provider: "slack", uid: "U123").user_id
    follow_redirect! while response.redirect?
    assert_match "connected to another DevCongress Connect account", response.body
  end

  test "disconnecting" do
    @user.identities.create!(provider: "slack", uid: "U123")
    @user.slack_connected!
    login_user(@user)

    delete "/dashboard/settings/slack"

    # Tightened to /dashboard/settings/notifications once that page exists.
    assert_response :redirect
    assert_nil @user.reload.slack_identity
    assert @user.wants_notification?(:applications, via: :email)
  end

  test "can't disconnect the only way to sign in" do
    user = User.create!(email: "slackonly@example.com", status: :verified)
    create_profile!(user:)
    # No password, so sign in with Slack (links U555 by verified email).
    mock_slack(uid: "U555", email: user.email)
    post "/users/auth/slack"
    follow_redirect! while response.redirect?

    delete "/dashboard/settings/slack"

    assert_equal "U555", user.reload.slack_identity.uid
    follow_redirect!
    assert_match "Set a password first", response.body
  end

  private

  def mock_slack(uid:, email:)
    OmniAuth.config.mock_auth[:slack] = OmniAuth::AuthHash.new(
      provider: "slack", uid:, info: {email:, name: "Ama Mensah"},
      extra: {raw_info: {"https://slack.com/team_id" => "T0DEVCON", "email_verified" => true}}
    )
  end
end
