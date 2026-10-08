require "test_helper"

class EmailUnsubscribeTest < ActionDispatch::IntegrationTest
  include AccountsTestHelper

  setup do
    @user = create_user!
    @token = EmailOptOut.token_for(@user, :network)
  end

  test "opening the link asks before turning anything off" do
    get "/unsubscribe/#{@token}"

    assert_response :success
    assert_select "h1", /Turn off network activity emails/
    assert @user.wants_email?(:network)
  end

  test "confirming turns the category off without signing in" do
    post "/unsubscribe/#{@token}"

    assert_response :success
    assert_select "h1", /won't get network activity emails/
    assert_not @user.wants_email?(:network)
    assert @user.wants_email?(:applications)
  end

  test "mail clients can unsubscribe in one click, without a CSRF token" do
    ActionController::Base.allow_forgery_protection = true
    post "/unsubscribe/#{@token}", params: {"List-Unsubscribe" => "One-Click"}

    assert_response :success
    assert_not @user.wants_email?(:network)
  ensure
    ActionController::Base.allow_forgery_protection = false
  end

  test "bad tokens are not found" do
    get "/unsubscribe/nope"
    assert_response :not_found

    post "/unsubscribe/nope"
    assert_response :not_found
  end
end
